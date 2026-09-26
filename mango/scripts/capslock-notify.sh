#!/usr/bin/env bash
# ~/.local/bin/capslock-notify.sh
prev=""
while true; do
    state=$(cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -1)
    if [ "$state" != "$prev" ]; then
        if [ "$state" = "1" ]; then
            notify-send "Caps Lock" "ON" -i keyboard -t 1500 -u low
        else
            notify-send "Caps Lock" "OFF" -i keyboard -t 1500 -u low
        fi
        prev="$state"
    fi
    sleep 0.2
done
