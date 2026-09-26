#!/bin/sh
LOGFILE="$HOME/.local/share/mako/notifications.log"
mkdir -p "$(dirname "$LOGFILE")"

dbus-monitor --session "type='method_call',interface='org.freedesktop.Notifications',member='Notify'" 2>/dev/null | \
awk '
/member=Notify/ { count=0; app=""; summary=""; body="" }
/^   string / {
    gsub(/^   string "/, ""); gsub(/"$/, "")
    count++
    if (count==1) app=$0
    if (count==3) summary=$0
    if (count==4) {
        body=$0
        if (app == "Volume" || app == "Brightness") next
        cmd="date +%Y-%m-%d_%H:%M:%S"
        cmd | getline ts
        close(cmd)
        if (summary != "") {
            print ts " | " app " | " summary " | " body >> LOGFILE
            fflush()
        }
    }
}' LOGFILE="$LOGFILE"
