#!/usr/bin/env bash

# Get volume information using pamixer
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    echo "󰖁"  # Muted icon
elif [ "$volume" -eq 0 ]; then
    echo "󰕿"  # Volume 0 icon
elif [ "$volume" -lt 30 ]; then
    echo "󰖀"  # Low volume icon
elif [ "$volume" -lt 70 ]; then
    echo "󰕾"  # Medium volume icon
else
    echo "󰕾"  # High volume icon
fi