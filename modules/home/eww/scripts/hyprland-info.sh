#!/usr/bin/env bash

case "$1" in
  "workspaces")
    # Get workspace info from hyprland
    hyprctl workspaces -j | jq -c '[.[] | {id: .id, name: .name, windows: .windows, active: false, urgent: false, icon: (if .id == 1 then "󰈹" elif .id == 2 then "" elif .id == 3 then "" elif .id == 4 then "󰽰" elif .id == 5 then "󰝚" else "" end)}] | sort_by(.id)'
    ;;
  "active-workspace")
    # Get currently active workspace
    hyprctl activeworkspace -j | jq -r '.id'
    ;;
  "window-title")
    # Get active window title/class
    hyprctl activewindow -j | jq -r '.class // ""' | head -c 20
    ;;
  "network-status")
    # Get network status
    if nmcli device status | grep -q "wifi.*connected"; then
      echo "Connected (WiFi)"
    elif nmcli device status | grep -q "ethernet.*connected"; then
      echo "Connected (Ethernet)"
    else
      echo "Disconnected"
    fi
    ;;
  "network-icon")
    # Get network icon
    if nmcli device status | grep -q "wifi.*connected"; then
      echo "󰤨"
    elif nmcli device status | grep -q "ethernet.*connected"; then
      echo "󰈀"
    else
      echo "󰤭"
    fi
    ;;
  *)
    echo "Usage: $0 {workspaces|active-workspace|window-title|network-status|network-icon}"
    exit 1
    ;;
esac