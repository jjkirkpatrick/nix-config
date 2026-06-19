# ======================================================================
# EVE ONLINE PER-CHARACTER WINDOW SNAPPING
# ======================================================================
# All Eve clients share one window class (steam_app_8500) and the
# character name only appears in the window TITLE ("EVE - <Character>")
# AFTER login. Static Hyprland windowrules evaluate at open-time (title
# is still "EVE"), so they cannot route by character. Instead this daemon
# listens to Hyprland's event socket and, the moment a title becomes
# "EVE - <Character>" for a known character, makes that window tiled and
# moves it to the character's workspace -- the layout engine arranges it
# alongside the other tiled windows (gaps, columns, reserved bar) natively.
#
# See: docs/superpowers/specs/2026-06-19-eve-window-snapping-design.md
# ======================================================================
{ pkgs, lib, inputs, ... }:
let
  # hyprctl from the SAME flake input as the running compositor (see
  # modules/core/hyperland.nix) so the IPC protocol versions always match.
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Character -> workspace. Each known character is routed to its workspace
  # as a TILED window; Hyprland's layout (dwindle) handles geometry, gaps,
  # and the reserved bar -- so the clients look and behave like every other
  # tiled window. On the 5120-wide DP-1 ultrawide, three tiled clients fall
  # into three side-by-side columns automatically (windows stay wider than
  # tall, so each dwindle split is vertical). Column order/ratio is
  # dwindle-determined (open/focus order), not fixed.
  # To add a character: copy a line. To move a character: change the number.
  layout = {
    "Test Coordinator" = 5;
    "Blue Caloria"     = 5;
    "CockMunch"        = 5;
  };

  # Render the attrset into bash associative-array lines: ["Blue Caloria"]="5"
  layoutLines = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (char: ws: ''  ["${char}"]="${toString ws}"'')
    layout);

  eve-window-snap = pkgs.writeShellApplication {
    name = "eve-window-snap";
    runtimeInputs = [ pkgs.socat pkgs.jq hyprland ];
    text = ''
      SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      # Character -> workspace
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
        local ws="''${LAYOUT[$char]:-}"
        if [[ -z "$ws" ]]; then return 0; fi
        if [[ "''${PLACED[$addr]:-}" == "$char" ]]; then return 0; fi
        # Ensure tiled (Eve may open floating), then route to the workspace.
        # The layout engine does the rest; we deliberately set no geometry.
        hyprctl --batch "dispatch settiled address:0x$addr ; dispatch movetoworkspacesilent $ws,address:0x$addr" >/dev/null || true
        PLACED[$addr]="$char"
        return 0
      }

      # Place any Eve clients that are ALREADY open (and already titled)
      # when we connect -- e.g. daemon (re)start, or Eve launched before
      # login. Event-driven snapping only fires on title CHANGES, so without
      # this such windows would never be placed until a relog. Reuses snap(),
      # so the PLACED guard still prevents fighting manual moves. Runs in the
      # main shell (process substitution) so PLACED writes persist.
      scan() {
        while IFS=$'\t' read -r addr title; do
          if [[ "$title" =~ $re ]]; then
            snap "''${addr#0x}" "''${BASH_REMATCH[1]}"
          fi
        done < <(hyprctl clients -j | jq -r '.[] | "\(.address)\t\(.title)"')
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
      #
      # socat MUST be unidirectional (-u, socket -> stdout). With plain "-"
      # (bidirectional stdio) socat also reads stdin, and under systemd a
      # service's stdin is /dev/null -> immediate EOF -> socat tears down the
      # connection after its half-close timeout (~0.5s). That made the daemon
      # listen only ~0.5s out of every couple seconds and miss most events.
      # We never write to the socket, so -u is both the fix and correct.
      while true; do
        if [[ -S "$SOCK" ]]; then
          scan
          while IFS= read -r line; do
            handle "$line"
          done < <(socat -u "UNIX-CONNECT:$SOCK" - 2>/dev/null) || true
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
