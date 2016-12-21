#!/bin/bash

while true; do
    for f in /tmp/biosensor_loop_motion_watchdog.*; do
        xpid="${f/*./}"
        if ! ps -p $xpid > /dev/null; then
            echo cleanup old pid $xpid
            rm "$f"
        else
            now=$(date +%s)
            too_old=$(($now - 60))
            xpid_ts=$(cat "$f")
            if [[ $xpid_ts -lt $too_old ]]; then
                echo pid is running, but is hanging...
                echo reboot to reset camera...
                sudo reboot
            fi
        fi
    done
    sleep 10
done

