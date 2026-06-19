# Eve Window Snapping Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Automatically snap each named Eve Online client to its own workspace/position/size the moment its character logs in.

**Architecture:** A bash daemon (`socat` + `hyprctl`) listens to Hyprland's event socket, matches `windowtitlev2` events against `^EVE - (.+)$`, looks the character up in a declarative Nix-generated table, and dispatches `setfloating`/`movetoworkspacesilent`/`resizewindowpixel`/`movewindowpixel`. Packaged as a home-manager module with the geometry table as a Nix attrset and run as a systemd user service.

**Tech Stack:** Nix / home-manager, bash, `socat`, `hyprctl`, systemd user service. Hyprland 0.55.0.

**Spec:** `docs/superpowers/specs/2026-06-19-eve-window-snapping-design.md`

---

## File Structure

- **Create:** `modules/home/eve-window-manager.nix` — the whole feature: layout attrset → generated `eve-window-snap` script (via `writeShellApplication`) + systemd user service. One file, one responsibility.
- **Modify:** `modules/home/default.nix` — add the new module to `imports`.

## Conventions in this repo (follow these)

- systemd user services use the home-manager capitalized schema (`Unit`/`Service`/`Install`) — see `modules/home/nemoclaw.nix`.
- The socket2 listener pattern already exists in `modules/home/config/waybar/scripts/calendar-popup.sh` (`socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"`).
- `socat` is already installed (`modules/home/packages/gui.nix`).
- **CRITICAL — flake eval only sees git-tracked files:** run `git add` for new/changed files *before* any `nh`/`home-manager` rebuild, or Nix won't see them.
- Rebuild home-manager with `nh home switch .` (preferred per CLAUDE.md).

---

### Task 1: De-risk coordinates with a manual dry-run

Confirm the target geometry is correct against the live `EVE - Blue Caloria` window *before* writing any automation. No code yet.

**Files:** none.

- [ ] **Step 1: Get the live window address**

Run:
```bash
hyprctl clients -j | jq -r '.[] | select(.title=="EVE - Blue Caloria") | .address'
```
Expected: a single address like `0x5cef26ab3260`. If empty, log in Blue Caloria first. Save it as `ADDR` below.

- [ ] **Step 2: Dispatch the Blue Caloria layout by hand**

Replace `0xADDR` with the address from Step 1:
```bash
hyprctl dispatch setfloating address:0xADDR
hyprctl dispatch movetoworkspacesilent 5,address:0xADDR
hyprctl dispatch resizewindowpixel "exact 3414 1440,address:0xADDR"
hyprctl dispatch movewindowpixel "exact 853 1080,address:0xADDR"
```
Expected: each prints `ok`.

- [ ] **Step 3: Verify it landed**

Run:
```bash
hyprctl clients -j | jq -r '.[] | select(.title=="EVE - Blue Caloria") | "ws=\(.workspace.name) floating=\(.floating) at=\(.at) size=\(.size)"'
```
Expected: `ws=5 floating=true at=[853,1080] size=[3414,1440]`.

If the numbers are off (e.g. monitor offset wrong), STOP and reconcile the geometry table in the spec before continuing — the rest of the plan bakes in these coordinates.

---

### Task 2: Create the home-manager module (script + mapping)

**Files:**
- Create: `modules/home/eve-window-manager.nix`

- [ ] **Step 1: Write the module**

Create `modules/home/eve-window-manager.nix` with exactly this content:

```nix
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
{ pkgs, lib, ... }:
let
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
    runtimeInputs = [ pkgs.socat pkgs.hyprland ];
    text = ''
      SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      # Character -> "WS X Y W H" (Hyprland global coordinates)
      declare -A LAYOUT=(
      ${layoutLines}
      )

      # addr -> character already placed (avoids fighting manual moves)
      declare -A PLACED=()

      re='^EVE - (.+)$'

      snap() {
        local addr="$1" char="$2"
        local spec="''${LAYOUT[$char]:-}"
        if [[ -z "$spec" ]]; then return 0; fi
        if [[ "''${PLACED[$addr]:-}" == "$char" ]]; then return 0; fi
        local ws x y w h
        read -r ws x y w h <<<"$spec"
        hyprctl dispatch setfloating "address:0x$addr" >/dev/null || true
        hyprctl dispatch movetoworkspacesilent "$ws,address:0x$addr" >/dev/null || true
        hyprctl dispatch resizewindowpixel "exact $w $h,address:0x$addr" >/dev/null || true
        hyprctl dispatch movewindowpixel "exact $x $y,address:0x$addr" >/dev/null || true
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

      # Reconnect loop: survives Hyprland restarts.
      while true; do
        if [[ -S "$SOCK" ]]; then
          socat - "UNIX-CONNECT:$SOCK" 2>/dev/null | while IFS= read -r line; do
            handle "$line"
          done || true
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
```

- [ ] **Step 2: Import the module**

In `modules/home/default.nix`, add to the `imports` list (after `./reading.nix`):
```nix
    ./eve-window-manager.nix          # Eve Online per-character window snapping
```

- [ ] **Step 3: Stage files so Nix can see them (REQUIRED before build)**

Run:
```bash
git add modules/home/eve-window-manager.nix modules/home/default.nix
```
Expected: no output. (Flake eval ignores untracked files — skipping this makes the build fail with "file not found".)

- [ ] **Step 4: Build to verify it evaluates and the script passes shellcheck**

Run:
```bash
nh home switch .
```
Expected: build succeeds and a diff shows `eve-window-snap` added. `writeShellApplication` runs shellcheck at build time — if it fails, fix the reported line in the `text` block and re-stage + rebuild.

---

### Task 3: Verify the listener reacts (standalone, before trusting the service)

**Files:** none.

- [ ] **Step 1: Confirm the binary is on PATH**

Run:
```bash
command -v eve-window-snap
```
Expected: a `/nix/store/...` or `~/.nix-profile/bin/eve-window-snap` path.

- [ ] **Step 2: Move a test window out of place, then run the listener in the foreground**

First nudge Blue Caloria somewhere wrong so a successful snap is observable:
```bash
ADDR=$(hyprctl clients -j | jq -r '.[] | select(.title=="EVE - Blue Caloria") | .address')
hyprctl dispatch movetoworkspacesilent 9,address:$ADDR
```
Then run the daemon in the foreground:
```bash
eve-window-snap
```
Leave it running. In Eve, click away from and back into the character (or relog) so the title is re-emitted as `EVE - Blue Caloria`. (If a relog isn't convenient, Step 3 provides a synthetic trigger instead.)

Expected: the window jumps to ws5 at (853,1080), size 3414x1440.

- [ ] **Step 3 (fallback synthetic trigger): force a title event**

If you can't make Eve re-emit the title, in a second terminal simulate the placement by feeding the daemon's own logic — set the window to floating-unaware state and re-trigger by toggling the title via Eve. As a last resort, verify the parse + dispatch path directly:
```bash
ADDR=$(hyprctl clients -j | jq -r '.[] | select(.title=="EVE - Blue Caloria") | .address' | sed 's/^0x//')
# Mimic exactly what handle() does for one event:
title="EVE - Blue Caloria"; re='^EVE - (.+)$'
[[ "$title" =~ $re ]] && echo "matched char: ${BASH_REMATCH[1]}"
```
Expected: `matched char: Blue Caloria`. This confirms the regex/parse; the live relog in Step 2 confirms the full dispatch.

- [ ] **Step 4: Stop the foreground listener**

Press `Ctrl-C`. Expected: returns to prompt.

---

### Task 4: Verify the systemd service and the manual-move guard

**Files:** none (the service was defined in Task 2; `nh home switch` already installed and started it).

- [ ] **Step 1: Confirm the service is active**

Run:
```bash
systemctl --user status eve-window-snap --no-pager
```
Expected: `Active: active (running)`. If `inactive`/`failed`, run `systemctl --user restart eve-window-snap` and re-check; inspect `journalctl --user -u eve-window-snap -n 50 --no-pager` on failure.

- [ ] **Step 2: End-to-end reaction test**

Relog (or re-focus) `Blue Caloria`, `Test Coordinator`, and `CockMunch` in turn.
Expected: each snaps to its column on ws5 —
```
hyprctl clients -j | jq -r '.[] | select(.title|startswith("EVE - ")) | "\(.title): ws=\(.workspace.name) at=\(.at) size=\(.size)"'
```
shows Test Coordinator at `[0,1080] [853,1440]`, Blue Caloria at `[853,1080] [3414,1440]`, CockMunch at `[4267,1080] [853,1440]`.

- [ ] **Step 3: Verify the guard does not fight manual moves**

Drag one placed Eve window elsewhere by hand. Expected: it stays where you put it (no event re-fires because the title didn't change, and the per-address guard would block re-placement anyway).

- [ ] **Step 4: Verify an unknown character is ignored**

Log in a character NOT in the table. Expected: it opens as a normal tiled window, untouched.

- [ ] **Step 5: Commit**

```bash
git add modules/home/eve-window-manager.nix modules/home/default.nix
git commit -m "Add Eve per-character window snapping daemon

Listens to Hyprland's event socket and snaps each known Eve character
to its pinned workspace/position/size on login. Mapping is a declarative
Nix attrset; runs as a systemd user service.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```
Expected: commit succeeds.

---

## Self-Review

- **Spec coverage:** listener script (Task 2) ✓; declarative Nix mapping with the three-character table (Task 2) ✓; systemd user service (Task 2/4) ✓; reconnect loop (in script) ✓; per-address guard + closewindow re-arm (in script, Task 4 Step 3) ✓; unknown-character ignore (Task 4 Step 4) ✓; global-coordinate `y=1080` offset (table) ✓; manual dry-run verification (Task 1) ✓.
- **Coordinates:** 853 + 3414 + 853 = 5120 ✓; all match the spec table.
- **Naming consistency:** `eve-window-snap` (binary + service), `eve-window-manager.nix` (module), `LAYOUT`/`PLACED`/`snap`/`handle` used consistently across script and tasks.
- **Repo gotcha honored:** `git add` before every rebuild (Task 2 Step 3, Task 4 Step 5).
