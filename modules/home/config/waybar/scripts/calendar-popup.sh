#!/usr/bin/env bash
# Toggle gsimplecal popup — auto-closes when focus moves away

if pgrep -x gsimplecal > /dev/null; then
    pkill -x gsimplecal
    exit 0
fi

gsimplecal &

(
    # Wait for gsimplecal to receive focus (up to 2s)
    for _ in $(seq 20); do
        sleep 0.1
        [[ "$(hyprctl activewindow -j 2>/dev/null | jq -r '.class')" == "gsimplecal" ]] && break
    done

    # Close when focus moves to any other window
    socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" 2>/dev/null \
    | while IFS= read -r line; do
        [[ "$line" == activewindow\>* ]] || continue
        class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // ""')
        [[ "$class" != "gsimplecal" ]] && pkill -x gsimplecal && break
    done
) &
