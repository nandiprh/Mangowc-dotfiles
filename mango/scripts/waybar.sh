#!/bin/sh
# ~/.local/bin/waybar.sh

if pgrep -x waybar >/dev/null; then
    pkill waybar
else
    waybar &
fi
