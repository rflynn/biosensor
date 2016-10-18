#!/bin/bash

set -x

while true; do
	hour=$(date +%H)
	if [ $hour -ge 6 ] && [ $hour -le 18 ]; then
		/bin/bash snapshot.sh
		sleep 4
	else
		echo "too dark at $hour, waiting..."
		sleep 60
	fi
done
