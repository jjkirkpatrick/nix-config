#!/usr/bin/env bash
# Show days since last flake update
FLAKE_LOCK="$HOME/nix-config/flake.lock"

if [ ! -f "$FLAKE_LOCK" ]; then
    jq -n '{text: "N/A", tooltip: "flake.lock not found"}'
    exit 0
fi

last_update=$(stat -c %Y "$FLAKE_LOCK")
now=$(date +%s)
days=$(( (now - last_update) / 86400 ))

if [ "$days" -eq 0 ]; then
    age="Updated today"
elif [ "$days" -eq 1 ]; then
    age="Updated 1 day ago"
else
    age="Updated ${days} days ago"
fi

if [ "$days" -ge 7 ]; then
    class="stale"
else
    class="ok"
fi

tooltip=$(printf '%s\nRun: nh os switch . to rebuild' "$age")
jq -cn --arg text "${days}d" --arg tooltip "$tooltip" --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
