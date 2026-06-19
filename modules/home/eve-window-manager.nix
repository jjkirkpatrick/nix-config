# ======================================================================
# EVE ONLINE PER-CHARACTER WINDOW SNAPPING
# ======================================================================
# All Eve clients share one window class (steam_app_8500) and the
# character name only appears in the window TITLE ("EVE - <Character>")
# AFTER login. Static Hyprland windowrules evaluate at open-time (title
# is still "EVE"), so they cannot route by character. Instead this daemon
# listens to Hyprland's event socket and, the moment a title becomes
# "EVE - <Character>" for a known character, floats that window and snaps
# it to the character's slot (workspace + position + size). Geometry is
# chosen to mimic tiled columns (bar- and gap-aware) so a centered, larger
# main client can sit between two smaller alts -- which dwindle can't do.
#
# Two commands are produced from one shared layout table:
#   eve-window-snap  -- the long-running daemon (event-driven + startup scan)
#   eve-window-place -- a one-shot that snaps all current clients now; bound
#                       to a key so the layout can be re-applied on demand.
#
# See: docs/superpowers/specs/2026-06-19-eve-window-snapping-design.md
# ======================================================================
{ pkgs, lib, inputs, ... }:
let
  # hyprctl from the SAME flake input as the running compositor (see
  # modules/core/hyperland.nix) so the IPC protocol versions always match.
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Character -> workspace + floating geometry on Hyprland's GLOBAL coords.
  # Floating (not tiled) because dwindle's binary splits can't make the
  # MIDDLE window the biggest -- and Blue must be centered and largest.
  # Coordinates are chosen to mimic tiled columns so they look native:
  #   - DP-1 is 5120x1440 at global offset (0,1080); a 45px waybar is
  #     reserved at the top, so usable y starts at 1080+45 = 1125.
  #   - gaps_out=10 (screen edge) and 2*gaps_in=10 (between windows) are
  #     baked in: top y=1135, height=1375, left x=10, right edge=5110.
  #   - widths: Blue = half (2540), the two alts a quarter each (1270),
  #     with 10px gaps: 10 +1270+10 +2540+10 +1270 = 5110 (= 5120 - 10).
  # To add a character: copy a line. To resize a slot: edit the numbers.
  layout = {
    "Test Coordinator" = { ws = 5; x = 10;   y = 1135; w = 1270; h = 1375; };
    "Blue Caloria"     = { ws = 5; x = 1290; y = 1135; w = 2540; h = 1375; };
    "CockMunch"        = { ws = 5; x = 3840; y = 1135; w = 1270; h = 1375; };
  };

  # Render the attrset into bash associative-array lines:
  #   ["Blue Caloria"]="5 1290 1135 2540 1375"
  layoutLines = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (char: g:
      ''  ["${char}"]="${toString g.ws} ${toString g.x} ${toString g.y} ${toString g.w} ${toString g.h}"'')
    layout);

  # Shared bash: the layout table, the placement guard, and snap()/scan().
  # Used verbatim by both the daemon and the one-shot so there is a single
  # source of truth for the character mapping and placement behaviour.
  placeLib = ''
    # Character -> "WS X Y W H" (Hyprland global coordinates)
    declare -A LAYOUT=(
    ${layoutLines}
    )

    # addr -> character already placed. In the daemon this prevents fighting
    # a window the user has manually moved; it lives in the main shell (the
    # read loop uses process substitution, not a pipe) so it survives socat
    # reconnects. The one-shot starts with an empty guard, so it always
    # (re)places every current client -- exactly what a manual trigger wants.
    declare -A PLACED=()

    re='^EVE - (.+)$'

    snap() {
      local addr="$1" char="$2"
      local spec="''${LAYOUT[$char]:-}"
      if [[ -z "$spec" ]]; then return 0; fi
      if [[ "''${PLACED[$addr]:-}" == "$char" ]]; then return 0; fi
      local ws x y w h
      read -r ws x y w h <<<"$spec"
      # Float and route to the workspace first.
      hyprctl --batch "dispatch setfloating address:0x$addr ; dispatch movetoworkspacesilent $ws,address:0x$addr" >/dev/null || true
      # Then size+position. The FIRST resize right after a float transition
      # lands slightly off (window still settling), so apply it twice -- the
      # second pass is exact. Cheap and idempotent.
      for _ in 1 2; do
        hyprctl --batch "dispatch resizewindowpixel exact $w $h,address:0x$addr ; dispatch movewindowpixel exact $x $y,address:0x$addr" >/dev/null || true
      done
      PLACED[$addr]="$char"
      return 0
    }

    # Place every currently-open, already-titled Eve client. The daemon calls
    # this on connect (startup / Hyprland-restart reconnect) so clients opened
    # before it started get placed without a relog; the one-shot calls it to
    # re-apply the layout on demand. Runs in the main shell (process
    # substitution) so PLACED writes persist.
    scan() {
      while IFS=$'\t' read -r addr title; do
        if [[ "$title" =~ $re ]]; then
          snap "''${addr#0x}" "''${BASH_REMATCH[1]}"
        fi
      done < <(hyprctl clients -j | jq -r '.[] | "\(.address)\t\(.title)"')
    }
  '';

  # Long-running daemon: react to live title changes, plus a startup scan.
  eve-window-snap = pkgs.writeShellApplication {
    name = "eve-window-snap";
    runtimeInputs = [ pkgs.socat pkgs.jq hyprland ];
    text = ''
      SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      ${placeLib}

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

  # One-shot: snap all current Eve clients now, then exit. Bound to a key.
  eve-window-place = pkgs.writeShellApplication {
    name = "eve-window-place";
    runtimeInputs = [ pkgs.jq hyprland ];
    text = ''
      ${placeLib}

      scan
    '';
  };

  # Full "start my Eve session" macro (bound to a key): snap the clients,
  # clear workspace 3, then open the wormhole map there in a fresh window.
  eve-session = pkgs.writeShellApplication {
    name = "eve-session";
    # NB: no chrome in runtimeInputs on purpose -- we call the user's own
    # google-chrome-stable via the ambient PATH so it talks to their already
    # running instance. Bundling a (possibly different-version) chrome here
    # hits Chrome's singleton profile lock and silently fails to open a window.
    runtimeInputs = [ pkgs.jq hyprland ];
    text = ''
      ${placeLib}

      URL="https://wormhole.systems/maps/wormageddon-490"

      # 1. Snap the Eve clients to their slots FIRST. This moves any client
      #    titled "EVE - <Char>" to ws5, so the ws3 purge below can never
      #    close a game client that happens to be sitting on ws3.
      scan

      # 2. Close everything left on workspace 3 (EVE Launcher, strays) to
      #    make room for a fresh map.
      while IFS= read -r addr; do
        [[ -n "$addr" ]] && hyprctl dispatch closewindow "address:$addr" >/dev/null || true
      done < <(hyprctl clients -j | jq -r '.[] | select(.workspace.name=="3") | .address')

      # 3. Open the wormhole map on ws3. A new browser window opens on the
      #    ACTIVE workspace (which follows the mouse), so opening it blindly
      #    makes it flash into the user's current layout before we could move
      #    it. Instead we focus ws3 FIRST (it lives on the secondary monitor,
      #    so the main view is untouched) -- the new window then opens on ws3
      #    directly. We call the user's own google-chrome-stable (via PATH) so
      #    it talks to the running instance and keeps their profile/login.
      orig="$(hyprctl activeworkspace -j | jq -r '.name')"
      hyprctl dispatch workspace 3 >/dev/null || true
      google-chrome-stable --new-window "$URL" >/dev/null 2>&1 &
      disown

      # Belt-and-suspenders: if chrome reused a window that was elsewhere,
      # pull whatever shows the map onto ws3 once it appears.
      for _ in $(seq 40); do          # poll up to ~12s
        addr="$(hyprctl clients -j | jq -r 'first(.[] | select(.title|test("wormhole|wormageddon";"i")) | .address) // empty')"
        if [[ -n "$addr" ]]; then
          hyprctl dispatch movetoworkspacesilent "3,address:$addr" >/dev/null || true
          break
        fi
        read -t 0.3 -r _ </dev/null 2>/dev/null || true
      done

      # Return focus to wherever the user was, so the macro doesn't leave them
      # parked on ws3.
      hyprctl dispatch workspace "$orig" >/dev/null || true
    '';
  };
in
{
  home.packages = [ eve-window-snap eve-window-place eve-session ];

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
