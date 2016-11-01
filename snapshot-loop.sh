#!/bin/bash

set -x

while true; do
	hour=$(date +%H)
	if [ $hour -ge 8 ] && [ $hour -lt 18 ]; then
		/bin/bash snapshot.sh
		sleep 2
	else
		echo "too dark at $hour, waiting..."
		sleep 60
	fi
done
