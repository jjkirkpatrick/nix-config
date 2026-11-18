# Weekly automatic update, keeping the repo and the running system in sync.
#
# Replaces system.autoUpgrade, which built against an unpinned nixpkgs
# (--update-input --no-write-lock-file) so the system silently drifted from
# flake.lock, and failed for weeks without anyone noticing.
#
# Flow (as ${username} unless noted):
#   1. skip (and notify) if the checkout is dirty or not on main
#   2. git pull --ff-only, nix flake update
#   3. build the system; on failure restore flake.lock and notify
#   4. commit + push flake.lock
#   5. (root) register the build as the next boot generation
#
# "boot", not "switch": a live NVIDIA driver bump breaks the CDI generator and
# aborts activation, so updates land on the next reboot.
#
# Run by hand:  sudo systemctl start nix-config-update
# Logs:         journalctl -u nix-config-update
{ pkgs, username, host, ... }:

let
  flakePath = "/home/${username}/nix-config";
  uid = "1000";

  update = pkgs.writeShellApplication {
    name = "nix-config-update";
    runtimeInputs = with pkgs; [ git nix util-linux libnotify coreutils gh ];
    text = ''
      repo=${flakePath}
      as_user() {
        runuser -u ${username} -- env HOME=/home/${username} \
          XDG_RUNTIME_DIR=/run/user/${uid} \
          DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus "$@"
      }
      notify() { as_user notify-send -a "nix-config-update" "$@" || true; }
      g() { as_user git -C "$repo" "$@"; }

      if [ "$(g rev-parse --abbrev-ref HEAD)" != main ] || [ -n "$(g status --porcelain)" ]; then
        notify -u normal "System update skipped" "nix-config has uncommitted changes or isn't on main."
        exit 0
      fi

      g pull --ff-only
      as_user nix flake update --flake "$repo"

      if g diff --quiet flake.lock; then
        echo "flake.lock unchanged; nothing to do"
        exit 0
      fi

      if ! out=$(as_user nix build --no-link --print-out-paths --print-build-logs \
            "$repo#nixosConfigurations.${host}.config.system.build.toplevel"); then
        g checkout -- flake.lock
        notify -u critical "System update FAILED" "Build broke after flake update. See: journalctl -u nix-config-update"
        exit 1
      fi

      g commit -m "flake.lock: automatic weekly update" -- flake.lock
      g push || notify -u normal "System update: push failed" "flake.lock committed locally but not pushed."

      nix-env -p /nix/var/nix/profiles/system --set "$out"
      "$out/bin/switch-to-configuration" boot
      notify -u normal "System update ready" "New generation staged; reboot to apply."
    '';
  };
in
{
  # git refuses to read a repo owned by another user unless it's marked safe.
  programs.git.enable = true;
  programs.git.config.safe.directory = [ flakePath ];

  systemd.services.nix-config-update = {
    description = "Update flake inputs, build, commit and stage nix-config";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${update}/bin/nix-config-update";
    };
  };

  systemd.timers.nix-config-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = "45min";
      Persistent = true;
    };
  };
}
