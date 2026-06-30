# ======================================================================
# XWAYLAND -> WAYLAND CLIPBOARD BRIDGE (for Wine/Proton apps, e.g. EVE)
# ======================================================================
# Symptom: copying text in EVE Online pastes fine into the game itself and
# into other XWayland apps (Discord, Spotify) but NOT into native-Wayland
# apps (Brave, Chrome, VSCode, Kitty) -- Ctrl+V there pastes nothing.
#
# Root cause: EVE runs under Proton/Wine on XWayland. On copy, Wine writes
# the X11 CLIPBOARD selection correctly (xclip and other X11 clients read it
# fine). But Wine uses lazy "delayed-rendering" selection ownership, and
# wlroots' XWayland clipboard manager (Hyprland) does NOT mirror Wine's
# selection into the *Wayland* clipboard the way it does for ordinary X11
# clients. So native-Wayland apps -- which only read the Wayland clipboard --
# see nothing. (Verified: a generic X11 owner via xclip DOES sync to Wayland;
# only Wine's lazy ownership is missed. This is a Wine-under-wlroots quirk,
# not a Hyprland setting we can flip.)
#
# Fix: a tiny daemon that polls the X11 clipboard and, whenever it holds
# content the Wayland clipboard lacks, pulls it (Wine answers our explicit
# SelectionRequest -- that path works) and pushes it to the Wayland clipboard
# via wl-copy. Polling (not event-driven) on purpose: the same lazy ownership
# that defeats Hyprland's XWM is unreliable to detect via XFixes/clipnotify,
# so we actively pull instead. Text-only, which is all EVE ever copies.
#
# Started from exec.conf (not graphical-session.target) -- see the note there
# and modules/home/eve-window-manager.nix for the same rationale.
# ======================================================================
{ pkgs, ... }:
let
  clipboard-bridge = pkgs.writeShellApplication {
    name = "clipboard-bridge";
    runtimeInputs = [ pkgs.xclip pkgs.wl-clipboard pkgs.coreutils ];
    text = ''
      # XWayland lives on :0 in this session; the user systemd manager only
      # imports WAYLAND_DISPLAY (see exec.conf), not DISPLAY, so default it.
      export DISPLAY="''${DISPLAY:-:0}"

      last=""
      while true; do
        # Read the X11 (XWayland) CLIPBOARD. Command substitution strips
        # trailing newlines; wl-paste --no-newline below matches that, so the
        # two sides compare apples-to-apples. Empty / no-owner -> xclip fails
        # and we simply skip this tick (never clobbering the Wayland side).
        if x11="$(xclip -selection clipboard -o 2>/dev/null)" && [[ -n "$x11" ]]; then
          sig="$(printf '%s' "$x11" | md5sum)"
          if [[ "$sig" != "$last" ]]; then
            # Only push when Wayland doesn't already have this exact content.
            # When a native-Wayland app copies, Hyprland mirrors it Wayland->X11,
            # so x11 would already equal the Wayland clipboard -- skipping then
            # avoids stealing ownership and avoids a copy feedback loop. The
            # remaining case (X11 has something Wayland lacks) is exactly the
            # Wine/EVE copy we exist to bridge.
            wl="$(wl-paste --no-newline 2>/dev/null || true)"
            if [[ "$x11" != "$wl" ]]; then
              printf '%s' "$x11" | wl-copy
            fi
            last="$sig"
          fi
        fi
        sleep 0.5
      done
    '';
  };
in
{
  home.packages = [ clipboard-bridge ];

  systemd.user.services.clipboard-bridge = {
    Unit = {
      Description = "Mirror XWayland (Wine/EVE) clipboard into the Wayland clipboard";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${clipboard-bridge}/bin/clipboard-bridge";
      # User systemd manager doesn't inherit DISPLAY; XWayland is :0 here.
      Environment = [ "DISPLAY=:0" ];
      Restart = "always";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
