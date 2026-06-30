#!/usr/bin/env bash

is_powered() {
  bluetoothctl show 2>/dev/null | grep -qi "powered: yes"
}

# Power the adapter on (if needed) and wait until BlueZ reports it ready, so the
# rest of the menu queries a settled adapter rather than racing a cold start.
ensure_powered() {
  is_powered && return 0
  bluetoothctl power on >/dev/null 2>&1
  for _ in $(seq 1 15); do          # up to ~3s (15 * 0.2s)
    is_powered && return 0
    sleep 0.2
  done
  return 1
}

# List paired devices, retrying briefly: a just-powered adapter can take a moment
# to re-export its stored devices on D-Bus, which previously left this empty and
# forced a re-pair. Works for any paired device — nothing is hardcoded.
paired_devices() {
  local out
  for _ in $(seq 1 10); do          # up to ~2s (10 * 0.2s)
    out=$(bluetoothctl devices Paired 2>/dev/null | grep "Device")
    [[ -n "$out" ]] && { printf '%s\n' "$out"; return 0; }
    sleep 0.2
  done
  return 0                          # genuinely no paired devices
}

ensure_powered

entries=""
if is_powered; then
  entries="󰂲  Power off\n"
  entries="${entries}󰂍  Scan for new devices\n"

  # Paired devices with connection status
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d' ' -f3-)
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
      entries="${entries}󰂱  Disconnect: $name|$mac\n"
    else
      entries="${entries}󰂯  Connect: $name|$mac\n"
    fi
  done < <(paired_devices)
else
  entries="󰂱  Power on\n"
fi

choice=$(printf "$entries" | fuzzel --dmenu --prompt "Bluetooth: " --width 40)
[[ -z "$choice" ]] && exit 0

if [[ "$choice" == *"Power off"* ]]; then
  bluetoothctl power off

elif [[ "$choice" == *"Power on"* ]]; then
  # Power on, wait for the adapter, then re-open so paired devices are listed.
  ensure_powered && exec "$0"

elif [[ "$choice" == *"Scan for new devices"* ]]; then
  # Scan for 8 seconds, collect discovered devices
  notify-send "Bluetooth" "Scanning for devices..." -t 3000 2>/dev/null || true
  discovered=$(bluetoothctl --timeout 8 scan on 2>/dev/null)

  # Get all visible devices (not already paired)
  paired_macs=$(bluetoothctl devices Paired 2>/dev/null | awk '{print $2}')
  scan_entries=""
  while IFS= read -r dev_line; do
    mac=$(echo "$dev_line" | awk '{print $2}')
    name=$(echo "$dev_line" | cut -d' ' -f3-)
    # Skip if already paired
    if echo "$paired_macs" | grep -q "$mac"; then continue; fi
    [[ -z "$name" || "$name" == "$mac" ]] && continue
    scan_entries="${scan_entries}󰂯  Pair: $name|$mac\n"
  done < <(bluetoothctl devices 2>/dev/null | grep "Device")

  if [[ -z "$scan_entries" ]]; then
    notify-send "Bluetooth" "No new devices found" -t 3000 2>/dev/null || true
    exit 0
  fi

  scan_choice=$(printf "$scan_entries" | fuzzel --dmenu --prompt "Pair device: " --width 40)
  [[ -z "$scan_choice" ]] && exit 0
  mac=$(echo "$scan_choice" | awk -F'|' '{print $2}')
  bluetoothctl pair "$mac" && bluetoothctl trust "$mac" && bluetoothctl connect "$mac"

elif [[ "$choice" == *"Connect:"* ]]; then
  mac=$(echo "$choice" | awk -F'|' '{print $2}')
  bluetoothctl connect "$mac"

elif [[ "$choice" == *"Disconnect:"* ]]; then
  mac=$(echo "$choice" | awk -F'|' '{print $2}')
  bluetoothctl disconnect "$mac"
fi
