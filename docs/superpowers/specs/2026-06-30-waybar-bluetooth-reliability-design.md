# Waybar Bluetooth reliability — design

**Date:** 2026-06-30
**Host:** blue-pc (desktop)
**Status:** approved (pending spec review)

## Problem

The Waybar Bluetooth control (custom `fuzzel` menu over `bluetoothctl`) frequently
shows **no paired devices**, leaving "Scan for new devices" as the only usable path.
The user ends up re-pairing headphones almost every session.

## Root cause

The pairing bond is **not** being lost. Live probe (adapter powered on) shows the
paired + trusted devices present:

```
Device 88:C9:E8:68:34:7F WH-1000XM5     # Paired + Trusted
Device CC:F9:F0:D3:22:F2 Josh's S24 Ultra
```

The failure is a **cold-start race** in the Waybar flow:

1. `hardware.bluetooth.powerOnBoot = false` → adapter is **off** at every boot.
   (The config comment cites laptop battery saving; `blue-pc` is a desktop, so this
   is pure downside.)
2. The menu, seeing the adapter off, only offers "Power on". The user clicks it.
3. The user re-opens the menu, but BlueZ has not finished re-exporting the stored
   devices on D-Bus yet, so `bluetoothctl devices Paired` returns **empty** → no
   "Connect:" entries → the only remaining option is Scan + Pair.

So the menu queries the paired list too early against a freshly-powered adapter.

## Goals

- Paired devices reliably appear as one-click **Connect:** entries — **for any paired
  device**, no device hardcoded.
- No second trip through the menu just to power the adapter on.
- Trusted devices auto-reconnect after boot when they are on.

## Non-goals

- No dual-boot link-key syncing (bond is not being lost).
- No replacement of the Waybar approach with a GUI app (user prefers the bar control).
- No new packages.

## Design

### 1. Adapter on at boot — `modules/core/bluetooth.nix`

- `hardware.bluetooth.powerOnBoot = true`.
- `hardware.bluetooth.settings.Policy.AutoEnable = true` (explicit; renders
  `AutoEnable=true` into `/etc/bluetooth/main.conf`).

Effect: the adapter is up and stored devices are enumerated before the user ever
clicks, eliminating the cold-start race at the source. Trusted devices reconnect on
boot.

### 2. Harden the menu — `modules/home/config/waybar/scripts/bluetooth-menu.sh`

- **Power-on-and-wait:** if the adapter is off when the menu opens, run
  `bluetoothctl power on`, then poll `bluetoothctl show` until `Powered: yes`
  (bounded, e.g. ~3s with a short sleep loop), then **continue in the same menu** —
  no forced re-open.
- **Robust paired query:** read paired devices with a brief retry so a just-powered
  adapter never yields an empty list. Every paired device is rendered as a
  `Connect:`/`Disconnect:` entry (generic — works for all paired devices, none
  special-cased).
- Scan + Pair flow stays as the fallback for genuinely new devices.

### 3. Status script — `modules/home/config/waybar/scripts/bluetooth.sh`

- Minor robustness only (defensive parsing); no visible behavior change.

## Acceptance

- After a fresh boot, opening the Waybar Bluetooth menu lists every paired device as a
  `Connect:` entry without any Scan/Pair step.
- If the adapter is ever off, opening the menu powers it on and shows paired devices in
  the same interaction.
- Adding/removing a paired device via the normal flow is reflected in the list with no
  script edits.

## Files touched

- `modules/core/bluetooth.nix`
- `modules/home/config/waybar/scripts/bluetooth-menu.sh`
- `modules/home/config/waybar/scripts/bluetooth.sh`

## Rebuild / verification notes

- Core change needs `nh os switch .` (or `sudo nixos-rebuild switch`); scripts are
  home-manager (`nh home switch .`).
- Repo gotcha: flake eval only sees **git-tracked** files — `git add` the changed
  files before rebuilding.
