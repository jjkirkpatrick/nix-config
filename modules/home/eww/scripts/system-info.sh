#!/usr/bin/env bash

case "$1" in
  "cpu")
    # Get CPU usage percentage
    cpu_usage=$(awk '{u=$2+$4; t=$2+$3+$4+$5} END {if(t>0) print (100*u/t); else print 0}' /proc/stat 2>/dev/null || echo "0")
    printf "%.0f\n" "$cpu_usage"
    ;;
  "ram")
    # Get RAM usage percentage with better error handling
    ram_usage=$(free -m 2>/dev/null | grep Mem | awk '{if($2>0) print ($3/$2)*100; else print 0}' 2>/dev/null || echo "0")
    # Ensure we have a valid number, default to 0 if empty or invalid
    if [ -z "$ram_usage" ] || ! [[ "$ram_usage" =~ ^[0-9]+\.?[0-9]*$ ]]; then
      ram_usage="0"
    fi
    printf "%.0f\n" "$ram_usage"
    ;;
  "volume-icon")
    # Get volume icon based on volume level and mute status
    if command -v pamixer >/dev/null 2>&1; then
      if pamixer --get-mute >/dev/null 2>&1 && [ "$(pamixer --get-mute)" = "true" ]; then
        echo "󰸈"
      else
        volume=$(pamixer --get-volume 2>/dev/null || echo "50")
        if [ "$volume" -ge 70 ]; then
          echo ""
        elif [ "$volume" -ge 30 ]; then
          echo ""
        else
          echo ""
        fi
      fi
    else
      echo ""
    fi
    ;;
  *)
    echo "Usage: $0 {cpu|ram|volume-icon}"
    exit 1
    ;;
esac