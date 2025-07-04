#!/bin/sh

# Disable mouse following
hyprctl keyword input:follow_mouse 0

# Close windows on workspaces 1 and 2
hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 or .workspace.id == 10) | .address' | xargs -I {} hyprctl dispatch closewindow address:{}

sleep 0.5

# Setup workspace 2
hyprctl dispatch workspace 1
hyprctl dispatch exec "[workspace 2 tile] brave"
sleep 1
hyprctl dispatch splitratio 0.75
sleep 0.5
hyprctl dispatch exec "[workspace 2 tile] cursor"
sleep 1
hyprctl dispatch splitratio 0.6
sleep 0.5
hyprctl dispatch exec "[workspace 2 tile] kitty"
sleep 1
hyprctl dispatch togglesplit
sleep 0.5
hyprctl dispatch exec "[workspace 2 tile] kitty"
sleep 1

# Setup workspace 10 (secondary monitor)
hyprctl dispatch workspace 10
sleep 0.5
hyprctl dispatch exec "discord"
sleep 1
hyprctl dispatch exec "brave --new-window https://youtube.com"
sleep 1

# Re-enable mouse following
hyprctl keyword input:follow_mouse 1