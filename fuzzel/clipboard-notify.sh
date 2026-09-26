#!/bin/sh
wl-paste --watch sh -c '
    content=$(wl-paste 2>/dev/null | head -c 60 | tr -d "\n")
    notify-send "Clipboard" "Copied: $content" -i edit-copy -t 1500 -u low
'
