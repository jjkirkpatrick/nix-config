#!/usr/bin/env bash
# (Hyprland Lua config: `hyprctl dispatch` takes hl.dsp.* Lua, and
# `hyprctl keyword` is gone -- settings go through `hyprctl eval`.)
d()      { hyprctl dispatch "$1" >/dev/null; }
luastr() { local s=${1//\\/\\\\}; printf '"%s"' "${s//\"/\\\"}"; }
run()    { d "hl.dsp.exec_cmd($(luastr "$1"))"; }
ws()     { d "hl.dsp.focus({ workspace = $1 })"; }
to_ws()  { d "hl.dsp.window.move({ workspace = $1, follow = false, window = \"address:$2\" })"; }
follow_mouse() { hyprctl eval "hl.config({ input = { follow_mouse = $1 } })" >/dev/null; }

follow_mouse 0

# Close windows on target workspaces
hyprctl clients -j | jq -r '.[] | select(.workspace.id == 1 or .workspace.id == 2 or .workspace.id == 3 or .workspace.id == 10) | .address' | while read -r a; do d "hl.dsp.window.close({ window = \"address:$a\" })"; done

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
ws 1
sleep 0.3

before=$(get_windows)
run "google-chrome-stable --new-window 'https://dev.azure.com/ans-devops/INT-RnD/_sprints/backlog/DevOps%20Team/INT-RnD' --new-tab 'https://github.com/'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 1 "$addr"

before=$(get_windows)
run "code"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 1 "$addr"

before=$(get_windows)
run "kitty"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 1 "$addr"

before=$(get_windows)
run "kitty"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 1 "$addr"

### Workspace 3 — lazydocker ###
before=$(get_windows)
run "kitty --hold -e lazydocker"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 3 "$addr"

### Workspace 2 — Teams ###
before=$(get_windows)
run "google-chrome-stable --new-window 'https://teams.microsoft.com'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 2 "$addr"

### Workspace 10 — Media ###
before=$(get_windows)
run "discord"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 10 "$addr"

before=$(get_windows)
run "spotify"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 10 "$addr"

before=$(get_windows)
run "google-chrome-stable --new-window 'https://youtube.com'"
addr=$(wait_for_window "$before")
[ -n "$addr" ] && to_ws 10 "$addr"

### Return focus to primary ###
ws 1
d 'hl.dsp.focus({ monitor = "desc:Samsung Electric Company LC49G95T" })'

follow_mouse 1
