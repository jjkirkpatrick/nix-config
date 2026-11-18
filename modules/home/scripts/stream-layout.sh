#!/usr/bin/env bash
# Stream Deck window layouts:  stream-layout work | game | clean
#
# Hyprland's Lua config turned `hyprctl dispatch` into a Lua evaluator, so the
# old `hyprctl dispatch workspace 2` one-liners stopped working; these helpers
# issue the equivalent hl.dsp.* calls.
set -u

d()        { hyprctl dispatch "$1" >/dev/null; }
luastr()   { local s=${1//\\/\\\\}; printf '"%s"' "${s//\"/\\\"}"; }
run()      { d "hl.dsp.exec_cmd($(luastr "$1"))"; }
ws()       { d "hl.dsp.focus({ workspace = $1 })"; }
layout()   { d "hl.dsp.layout($(luastr "$1"))"; }
close_ws() {
  hyprctl clients -j | jq -r --argjson w "$1" '.[] | select(.workspace.id == $w) | .address' |
    while read -r a; do d "hl.dsp.window.close({ window = \"address:$a\" })"; done
}

# Four tiled apps on workspace 2, chat + YouTube on workspace 1.
two_screen() {
  close_ws 1; close_ws 2
  ws 2; sleep 0.5
  run "[workspace 2 tile] google-chrome-stable"; sleep 1; layout "splitratio 0.25"; sleep 0.5
  run "[workspace 2 tile] $1";                   sleep 1; layout "splitratio 0.6";  sleep 0.5
  run "[workspace 2 tile] $2";                   sleep 1; layout "togglesplit";     sleep 0.5
  run "[workspace 2 tile] $3";                   sleep 0.5
  ws 1; sleep 0.5
  run "[workspace 1 tile] discord"; sleep 0.5
  run "[workspace 1 tile] google-chrome-stable --new-window https://youtube.com"; sleep 0.5
  ws 1
}

case "${1:-}" in
  work)  two_screen cursor kitty kitty ;;
  game)  two_screen steam runelite runelite ;;
  clean) for i in $(seq 1 10); do close_ws "$i"; done; ws 1 ;;
  *) echo "usage: stream-layout work|game|clean" >&2; exit 2 ;;
esac
