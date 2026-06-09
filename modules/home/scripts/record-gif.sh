#!/usr/bin/env bash
set -euo pipefail

PIDFILE=/tmp/record-gif.pid
PATHFILE=/tmp/record-gif.path

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    PID=$(cat "$PIDFILE")
    kill -SIGINT "$PID"
    while kill -0 "$PID" 2>/dev/null; do sleep 0.1; done
    rm -f "$PIDFILE"

    MP4=$(cat "$PATHFILE")
    rm -f "$PATHFILE"
    OUT="$HOME/Pictures/gif-$(date +%Y%m%d_%H%M%S).gif"

    notify-send "GIF" "Encoding..."
    ffmpeg -y -i "$MP4" -vf "fps=20,scale=720:-1:flags=lanczos" -f yuv4mpegpipe - 2>/dev/null \
        | gifski -o "$OUT" - >/dev/null 2>&1
    rm -f "$MP4"

    echo -n "$OUT" | wl-copy
    notify-send "GIF saved" "$OUT (path copied)"
else
    GEOM=$(slurp) || exit 0
    MP4="/tmp/record-gif-$(date +%s).mp4"
    echo -n "$MP4" > "$PATHFILE"

    notify-send "Recording GIF" "Super+Shift+G to stop"
    wf-recorder -g "$GEOM" -f "$MP4" -c libx264 -x yuv420p -r 30 &
    echo $! > "$PIDFILE"
fi
