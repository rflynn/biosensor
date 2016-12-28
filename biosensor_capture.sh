#!/bin/bash

cd /home/pi/src/biosensor

while true
do
    ./venv/bin/python snapshot_loop_motion.py
    sleep 5
done

