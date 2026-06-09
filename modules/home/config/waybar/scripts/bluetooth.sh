#!/usr/bin/env bash

powered=$(bluetoothctl show | grep -i "powered:" | awk '{print $2}')

if [[ "$powered" != "yes" ]]; then
  echo '{"text": "󰂲", "tooltip": "Bluetooth off", "class": "off"}'
  exit 0
fi

connected=$(bluetoothctl devices Connected 2>/dev/null | grep "Device")
count=$(echo "$connected" | grep -c "Device")
[[ -z "$connected" ]] && count=0

if [[ $count -eq 0 ]]; then
  echo '{"text": "󰂯", "tooltip": "Bluetooth on\nNo devices connected", "class": "on"}'
  exit 0
fi

device_name=$(echo "$connected" | head -1 | cut -d' ' -f3-)

tooltip="Bluetooth on\nConnected ($count):"
while IFS= read -r line; do
  name=$(echo "$line" | cut -d' ' -f3-)
  tooltip="$tooltip\n• $name"
done <<< "$connected"

echo "{\"text\": \"󰂱 $device_name\", \"tooltip\": \"$tooltip\", \"class\": \"connected\"}"
