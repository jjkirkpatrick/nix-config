#!/usr/bin/env bash
# NVIDIA GPU usage for waybar

data=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total \
    --format=csv,noheader,nounits 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$data" ]; then
    jq -cn '{text: "N/A", tooltip: "GPU query failed"}'
    exit 0
fi

usage=$(echo "$data" | awk -F', ' '{print $1}')
temp=$(echo "$data" | awk -F', ' '{print $2}')
mem_used=$(echo "$data" | awk -F', ' '{print $3}')
mem_total=$(echo "$data" | awk -F', ' '{print $4}')

tooltip=$(printf 'Usage: %s%%\nTemp: %s°C\nVRAM: %s / %s MiB' "$usage" "$temp" "$mem_used" "$mem_total")
jq -cn --arg text "${usage}%" --arg tooltip "$tooltip" \
    '{text: $text, tooltip: $tooltip}'
