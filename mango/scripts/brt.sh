#!/usr/bin/env bash
BRIGHTNESS_DIR="/sys/class/backlight/intel_backlight"
MAX=$(cat "$BRIGHTNESS_DIR/max_brightness")
STEP=$((MAX / 20))

case "$1" in
    up)
        CURRENT=$(cat "$BRIGHTNESS_DIR/brightness")
        NEW=$((CURRENT + STEP))
        [ "$NEW" -gt "$MAX" ] && NEW=$MAX
        echo "$NEW" > "$BRIGHTNESS_DIR/brightness"
        ;;
    down)
        CURRENT=$(cat "$BRIGHTNESS_DIR/brightness")
        NEW=$((CURRENT - STEP))
        [ "$NEW" -lt 0 ] && NEW=0
        echo "$NEW" > "$BRIGHTNESS_DIR/brightness"
        ;;
esac

PERCENT=$(( $(cat "$BRIGHTNESS_DIR/brightness") * 100 / MAX ))
notify-send "Brightness" "${PERCENT}%" -h string:x-canonical-private-synchronous:brightness-notif -t 1500
