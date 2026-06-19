# ======================================================================
# EVE ONLINE PER-CHARACTER WINDOW SNAPPING
# ======================================================================
# All Eve clients share one window class (steam_app_8500) and the
# character name only appears in the window TITLE ("EVE - <Character>")
# AFTER login. Static Hyprland windowrules evaluate at open-time (title
# is still "EVE"), so they cannot route by character. Instead this daemon
# listens to Hyprland's event socket and snaps a client into place the
# moment its title becomes "EVE - <Character>" for a known character.
#
# See: docs/superpowers/specs/2026-06-19-eve-window-snapping-design.md
# ======================================================================
{ pkgs, lib, inputs, ... }:
let
  # hyprctl from the SAME flake input as the running compositor (see
  # modules/core/hyperland.nix) so the IPC protocol versions always match.
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Character -> target geometry on Hyprland's GLOBAL coordinate space.
  # DP-1 is 5120x1440 at global offset (0,1080), so y carries that offset.
  # Blue Caloria is centered at 2/3 width; the two alts split the rest.
  # To add a character: copy a line. To change a slot: edit the numbers.
  layout = {
    "Test Coordinator" = { ws = 5; x = 0;    y = 1080; w = 853;  h = 1440; };
    "Blue Caloria"     = { ws = 5; x = 853;  y = 1080; w = 3414; h = 1440; };
    "CockMunch"        = { ws = 5; x = 4267; y = 1080; w = 853;  h = 1440; };
  };

  # Render the attrset into bash associative-array lines:
  #   ["Blue Caloria"]="5 853 1080 3414 1440"
  layoutLines = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (char: g:
      ''  ["${char}"]="${toString g.ws} ${toString g.x} ${toString g.y} ${toString g.w} ${toString g.h}"'')
    layout);

  eve-window-snap = pkgs.writeShellApplication {
    name = "eve-window-snap";
    runtimeInputs = [ pkgs.socat hyprland ];
    text = ''
      SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      # Character -> "WS X Y W H" (Hyprland global coordinates)
      declare -A LAYOUT=(
      ${layoutLines}
      )

      # addr -> character already placed (avoids fighting manual moves).
      # Lives in the main shell (the read loop below uses process
      # substitution, not a pipe), so it persists across reconnects.
      declare -A PLACED=()

      re='^EVE - (.+)$'

      snap() {
        local addr="$1" char="$2"
        local spec="''${LAYOUT[$char]:-}"
        if [[ -z "$spec" ]]; then return 0; fi
        if [[ "''${PLACED[$addr]:-}" == "$char" ]]; then return 0; fi
        local ws x y w h
        read -r ws x y w h <<<"$spec"
        # One atomic IPC batch: float, move to workspace, resize, position.
        hyprctl --batch "dispatch setfloating address:0x$addr ; dispatch movetoworkspacesilent $ws,address:0x$addr ; dispatch resizewindowpixel exact $w $h,address:0x$addr ; dispatch movewindowpixel exact $x $y,address:0x$addr" >/dev/null || true
        PLACED[$addr]="$char"
        return 0
      }

      handle() {
        local line="$1"
        case "$line" in
          windowtitlev2'>>'*)
            local rest="''${line#windowtitlev2>>}"
            local addr="''${rest%%,*}"
            local title="''${rest#*,}"
            if [[ "$title" =~ $re ]]; then
              snap "$addr" "''${BASH_REMATCH[1]}"
            else
              unset "PLACED[$addr]" 2>/dev/null || true
            fi
            ;;
          closewindow'>>'*)
            local addr="''${line#closewindow>>}"
            unset "PLACED[$addr]" 2>/dev/null || true
            ;;
        esac
        return 0
      }

      # Reconnect loop: survives Hyprland restarts. Process substitution
      # keeps the read loop (and PLACED) in the main shell.
      while true; do
        if [[ -S "$SOCK" ]]; then
          while IFS= read -r line; do
            handle "$line"
          done < <(socat - "UNIX-CONNECT:$SOCK" 2>/dev/null) || true
        fi
        sleep 2
      done
    '';
  };
in
{
  home.packages = [ eve-window-snap ];

  systemd.user.services.eve-window-snap = {
    Unit = {
      Description = "Eve Online per-character window snapping";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${eve-window-snap}/bin/eve-window-snap";
      Restart = "always";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
