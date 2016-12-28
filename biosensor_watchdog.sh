#!/bin/bash

set -x

while true; do
    for f in /tmp/biosensor_loop_motion_watchdog.*; do
        xpid="${f/*./}"
        if ! ps -p $xpid > /dev/null; then
            echo note cleanup old pid $xpid
            rm "$f"
        else
            echo ok pid $xpid is running...
            now=$(date +%s)
            sec=60
            too_old=$(($now - $sec))
            xpid_ts=$(cat "$f")
            if [[ $xpid_ts -ge $too_old ]]; then
                echo ok pid $xpid has updated watchdog within $sec seconds
            else
                echo fail pid $xpid has not updated watchdog within $sec seconds, rebooting...
                /usr/bin/sudo /sbin/reboot
            fi
        fi
    done
    sleep 30
done

