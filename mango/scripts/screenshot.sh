#!/usr/bin/env bash
# Screenshot using grim + slurp
DIR="/home/honken/Pictures/screenshots"
mkdir -p "$DIR"

case "$1" in
    area)
        FILE="$DIR/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
        grim -g "$(slurp)" "$FILE" 2>/dev/null
        if [ -f "$FILE" ]; then
            notify-send "Screenshot" "Saved: $(basename "$FILE")" -i camera-photo
            wl-copy < "$FILE"
        else
            notify-send "Screenshot" "Cancelled" -i dialog-cancel
        fi
        ;;
    full)
        FILE="$DIR/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
        grim "$FILE" 2>/dev/null
        if [ -f "$FILE" ]; then
            notify-send "Screenshot" "Saved: $(basename "$FILE")" -i camera-photo
            wl-copy < "$FILE"
        else
            notify-send "Screenshot" "Failed" -i dialog-error
        fi
        ;;
esac
