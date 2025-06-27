#!/usr/bin/env bash

# Spotify waybar module
# Shows current playing song with artist and title

# Check if Spotify is running
if ! pgrep -x "spotify" > /dev/null; then
    echo '{"text": "", "tooltip": "Spotify not running", "class": "disconnected"}'
    exit 0
fi

# Get current track info using playerctl
STATUS=$(playerctl --player=spotify status 2>/dev/null)
ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)
TITLE=$(playerctl --player=spotify metadata title 2>/dev/null)

# Check if we got valid data
if [[ -z "$ARTIST" || -z "$TITLE" ]]; then
    echo '{"text": " No track", "tooltip": "No track playing", "class": "paused"}'
    exit 0
fi

# Truncate long text
MAX_LENGTH=40
FULL_TEXT="$ARTIST - $TITLE"

if [[ ${#FULL_TEXT} -gt $MAX_LENGTH ]]; then
    DISPLAY_TEXT="${FULL_TEXT:0:$MAX_LENGTH}..."
else
    DISPLAY_TEXT="$FULL_TEXT"
fi

# Set icon based on status
case $STATUS in
    "Playing")
        ICON=""
        CLASS="playing"
        ;;
    "Paused")
        ICON=""
        CLASS="paused"
        ;;
    *)
        ICON=""
        CLASS="stopped"
        ;;
esac

# Output JSON for waybar
echo "{\"text\": \"$ICON $DISPLAY_TEXT\", \"tooltip\": \"$FULL_TEXT\", \"class\": \"$CLASS\"}"