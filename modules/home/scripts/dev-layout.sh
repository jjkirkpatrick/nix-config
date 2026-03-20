#!/usr/bin/env bash

hyprctl keyword input:follow_mouse 0

# Close windows on target workspaces
hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 or .workspace.id == 2 or .workspace.id == 3 or .workspace.id == 10) | .address' | xargs -I {} hyprctl dispatch closewindow address:{}

sleep 0.5

# Helper: wait for a new window to appear and return its address
wait_for_window() {
  local known="$1"
  local timeout=10
  local elapsed=0
  while [ $elapsed -lt $timeout ]; do
    local current
    current=$(hyprctl clients -j | jq -r '.[].address' | sort)
    local new_addr
    new_addr=$(comm -13 <(echo "$known") <(echo "$current") | head -1)
    if [ -n "$new_addr" ]; then
      echo "$new_addr"
      return 0
    fi
    sleep 0.3
    elapsed=$((elapsed + 1))
  done
  return 1
}

get_windows() {
  hyprctl clients -j | jq -r '.[].address' | sort
}

### Workspace 1 — Dev layout ###
hyprctl dispatch workspace 1
sleep 0.3

before=$(get_windows)
hyprctl dispatch exec "brave --user-data-dir=/tmp/brave-dev --new-window 'https://dev.azure.com/ans-devops/INT-RnD/_sprints/backlog/DevOps%20Team/INT-RnD' --new-tab 'https://github.com/'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 1,address:$addr

before=$(get_windows)
hyprctl dispatch exec "code"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 1,address:$addr

before=$(get_windows)
hyprctl dispatch exec "kitty"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 1,address:$addr

before=$(get_windows)
hyprctl dispatch exec "kitty"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 1,address:$addr

### Workspace 3 — lazydocker ###
before=$(get_windows)
hyprctl dispatch exec "kitty --hold -e lazydocker"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 3,address:$addr

### Workspace 2 — Teams ###
before=$(get_windows)
hyprctl dispatch exec "brave --user-data-dir=/tmp/brave-teams --new-window 'https://teams.microsoft.com'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 2,address:$addr

### Workspace 10 — Media ###
before=$(get_windows)
hyprctl dispatch exec "discord"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 10,address:$addr

before=$(get_windows)
hyprctl dispatch exec "spotify"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 10,address:$addr

before=$(get_windows)
hyprctl dispatch exec "brave --user-data-dir=/tmp/brave-media --new-window 'https://youtube.com'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && hyprctl dispatch movetoworkspacesilent 10,address:$addr

### Return focus to primary ###
hyprctl dispatch workspace 1
hyprctl dispatch focusmonitor DP-3

hyprctl keyword input:follow_mouse 1
