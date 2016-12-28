#!/bin/bash

for f in /tmp/biosensor_loop_motion_watchdog.*; do
    xpid="${f/*./}"
    if ! ps -p $xpid > /dev/null; then
        echo note cleanup old pid $xpid
        rm "$f"
    else
        echo note stopping pid $xpid
        kill $xpid &
        sleep 3
        kill -9 $xpid
        rm -f "$f"
    fi
done
