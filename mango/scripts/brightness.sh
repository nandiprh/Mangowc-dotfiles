#!/usr/bin/env bash
# Brightness control for intel_backlight via sysfs
BRIGHTNESS_DIR="/sys/class/backlight/intel_backlight"
MAX=$(cat "$BRIGHTNESS_DIR/max_brightness" 2>/dev/null || echo 488)
STEP=$((MAX / 20))

case "$1" in
    up)
        CURRENT=$(cat "$BRIGHTNESS_DIR/brightness" 2>/dev/null || echo 0)
        NEW=$((CURRENT + STEP))
        [ "$NEW" -gt "$MAX" ] && NEW=$MAX
        echo "$NEW" | tee "$BRIGHTNESS_DIR/brightness" 2>/dev/null
        PERCENT=$((NEW * 100 / MAX))
        notify-send "Brightness" "$PERCENT%" -i display-brightness
        ;;
    down)
        CURRENT=$(cat "$BRIGHTNESS_DIR/brightness" 2>/dev/null || echo 0)
        NEW=$((CURRENT - STEP))
        [ "$NEW" -lt 0 ] && NEW=0
        echo "$NEW" | tee "$BRIGHTNESS_DIR/brightness" 2>/dev/null
        PERCENT=$((NEW * 100 / MAX))
        notify-send "Brightness" "$PERCENT%" -i display-brightness
        ;;
esac