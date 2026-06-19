# Eve Online per-character window snapping

**Date:** 2026-06-19
**Host:** blue-pc · **User:** josh · **Compositor:** Hyprland 0.55.0 (Wayland)

> **Revisions during implementation (2026-06-19).** The sections below describe
> the original *floating + exact-geometry* design. Three things changed while
> building and verifying it; the shipped module reflects these:
>
> 1. **socat must be unidirectional.** `socat - UNIX-CONNECT:…` is bidirectional
>    stdio; under systemd a service's stdin is `/dev/null` → instant EOF → socat
>    tears down the connection after its half-close timeout (~0.5s). The daemon
>    listened only ~0.5s out of every ~2.5s and missed almost every event (it
>    passed every interactive test, because a terminal stdin never EOFs). Fixed
>    with `socat -u UNIX-CONNECT:$SOCK -`.
> 2. **Floating geometry, corrected (we tried tiling and reverted).** The first
>    floating attempt fought the 45px reserved waybar and applied geometry
>    during the float transition, producing inconsistent sizes. We briefly
>    switched to plain **tiling** so Hyprland would handle gaps/columns natively
>    — but dwindle makes binary splits and *cannot* make the middle window the
>    biggest, which the layout requires (Blue centered and largest). So the
>    final design is floating with **bar- and gap-aware** coordinates that mimic
>    tiled columns: usable area starts at y=1125 (below the bar), 10px outer and
>    inter-window gaps, widths 1270 / 2540 / 1270. Reliability fix: the first
>    `resizewindowpixel` right after `setfloating` lands slightly off, so snap
>    applies size+position **twice** (the second pass is exact).
> 3. **Startup scan added.** On connect (startup or Hyprland-restart reconnect)
>    the daemon enumerates existing windows and places any already-titled Eve
>    clients, so clients open before the daemon starts don't need a relog.

## Problem

Eve Online benefits from each client launching at a consistent size and position.
On this setup the user multiboxes several characters, and wants each *named
character* pinned to its own workspace, position, and size automatically.

The obstacle: every Eve client shares one window class (`steam_app_8500`), and
the character name only appears in the **window title** — as `EVE - <Character>`
— *after* login. Hyprland's static `windowrule`s are evaluated at window-open
time, when the title is still just `EVE`, so they cannot route by character.

Therefore matching must be **reactive on the title**, not static on the class.

## Approach

A small event-driven daemon watches Hyprland's event socket and snaps a client
into place the moment its title becomes `EVE - <Character>` for a known
character.

This was chosen over static `windowrule`s (can't see the post-login title) and
over polling `hyprctl clients` (wasteful, laggy). The event socket gives the
title-change the instant it happens.

## Components

### 1. Listener script (`pkgs.writeShellScript`, bash + `socat`)

- Connects to `$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock`
  via `socat`.
- Reads the event stream line by line. Relevant events:
  - `windowtitlev2>>ADDR,TITLE` — primary trigger.
  - `closewindow>>ADDR` — clears the placement guard for that address.
- On a title event, matches `^EVE - (.+)$`. If the captured character is in the
  mapping **and** that address has not already been placed for this character,
  it dispatches, in order, against `address:0x<ADDR>`:
  1. `dispatch setfloating address:0x<ADDR>`
  2. `dispatch movetoworkspacesilent <WS>,address:0x<ADDR>`
  3. `dispatch resizewindowpixel exact <W> <H>,address:0x<ADDR>`
  4. `dispatch movewindowpixel exact <X> <Y>,address:0x<ADDR>`
- Maintains an in-memory set of already-placed addresses so it will **not** fight
  the user if they manually move a window afterwards. The guard is re-armed when
  the title changes again (e.g. a relog goes `EVE - Char` → `EVE` → `EVE - Char`)
  and cleared on `closewindow`.
- **Reconnect loop:** if `socat` exits (Hyprland restart), the script waits
  briefly and reconnects rather than dying.

Note on event address format: socket2 emits addresses without the `0x` prefix
(e.g. `windowtitlev2>>5cef26ab3260,EVE - Blue Caloria`); dispatches require the
`0x` prefix (`address:0x5cef26ab3260`). The script prepends `0x`.

### 2. Declarative Nix mapping (`modules/home/eve-window-manager.nix`)

A home-manager module holding the character → geometry table as a Nix attrset.
The listener script is generated from this attrset, so adding a character or a
new workspace is a one-line edit.

Initial mapping (workspace 5, monitor DP-1 = 5120x1440 at global offset (0,1080);
Blue Caloria centered at 2/3 width, the two alts splitting the remaining third,
all full height):

| Character          | Workspace | x    | y    | width | height |
|--------------------|-----------|------|------|-------|--------|
| Test Coordinator   | 5         | 0    | 1080 | 853   | 1440   |
| Blue Caloria       | 5         | 853  | 1080 | 3414  | 1440   |
| CockMunch          | 5         | 4267 | 1080 | 853   | 1440   |

(853 + 3414 + 853 = 5120 ✓)

### 3. systemd user service

Runs the listener, bound to the graphical session
(`WantedBy=graphical-session.target`, `After=graphical-session.target`), with
`Restart=always`. More robust than a Hyprland `exec-once` because it survives
Hyprland config reloads and auto-restarts on failure. `socat` is provided on the
service `PATH` (or via `path = [ pkgs.socat ]` / added to home packages).

## Data flow

```
character logs in
  → Eve sets window title "EVE - Blue Caloria"
  → Hyprland emits  windowtitlev2>>ADDR,EVE - Blue Caloria  on .socket2.sock
  → listener matches ^EVE - (.+)$, looks up "Blue Caloria" in mapping
  → (if not already placed) dispatch: setfloating → movetoworkspacesilent 5
                                       → resizewindowpixel → movewindowpixel
  → window snapped; ADDR recorded as placed
```

## Edge cases

- **Unknown characters:** any `EVE - <X>` not in the mapping is ignored and left
  as the default tiled window — logging in an unlisted alt does nothing
  disruptive.
- **Title churn:** Eve's title is stable once logged in, so re-snapping does not
  happen mid-session; the per-address guard further prevents it. A relog re-arms
  placement.
- **Global coordinates:** `movewindowpixel exact` uses Hyprland's global
  coordinate space, which is why DP-1's `y=1080` offset is baked into the table.
  **If the monitor layout changes, the geometry table must be updated.**

## Testing / verification

1. **Dry-run coordinates** against the currently running Blue Caloria window by
   hand (`hyprctl dispatch setfloating ...`, `resizewindowpixel`,
   `movewindowpixel`) to confirm the numbers land correctly before wiring the
   daemon.
2. **Service health:** after enabling, `systemctl --user status <name>` shows
   active/running.
3. **Reaction:** relog a mapped character and confirm the window snaps to its
   slot.
4. **Guard:** manually drag a placed window and confirm it is not yanked back.

## Out of scope

- Switching Eve off Steam (umu-launcher / Lutris) — independent change, not
  pursued now. The daemon is launcher-agnostic because it matches on title, not
  class.
- Slot-based or uniform-size strategies (per-character pinning was chosen).
