#!/usr/bin/env bash
case "$1" in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
if echo "$VOL" | grep -q MUTED; then
    notify-send "Volume" "Muted" -h string:x-canonical-private-synchronous:volume-notif -t 1500
else
    PERCENT=$(echo "$VOL" | grep -oP '\d+\.\d+' | awk '{printf "%d", $1*100}')
    notify-send "Volume" "${PERCENT}%" -h string:x-canonical-private-synchronous:volume-notif -t 1500
fi
