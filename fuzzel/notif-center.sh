#!/bin/sh
LOGFILE="$HOME/.local/share/mako/notifications.log"

send_notif() {
    dbus-send --session --type=method_call --dest=org.freedesktop.Notifications \
        /org/freedesktop/Notifications org.freedesktop.Notifications.Notify \
        string:"Notifications" uint32:0 string:"" string:"$1" string:"$2" \
        array:string:"" dict:string:variant:"" int32:3000
}

if [ ! -f "$LOGFILE" ] || [ ! -s "$LOGFILE" ]; then
    send_notif "Notifications" "No notifications yet"
    exit 0
fi

while true; do
    [ ! -s "$LOGFILE" ] && exit 0

    choice=$(tail -n 30 "$LOGFILE" | tac | \
        awk -F' \\| ' '{printf "%-22s %-15s %s\n", $1, $3, $4}' | \
        fuzzel --dmenu \
            --prompt="󰂚  " \
            --anchor=top \
            --width=80 \
            --lines=15 \
            --font="JetBrains Mono Nerd Font:size=13" \
            --background=1a1b26cc \
            --text-color=c0caf5ff \
            --prompt-color=7aa2f7ff \
            --placeholder-color=565f77ff \
            --input-color=c0caf5ff \
            --match-color=7dcfffff \
            --selection-color=2a2c3dff \
            --selection-text-color=c0caf5ff \
            --selection-match-color=7aa2f7ff \
            --counter-color=565f77ff \
            --border-width=2 \
            --border-radius=12)

    [ -z "$choice" ] && exit 0

    timestamp=$(echo "$choice" | awk '{print $1}')
    grep -v "^$timestamp" "$LOGFILE" > /tmp/notif.tmp && mv /tmp/notif.tmp "$LOGFILE"
done
