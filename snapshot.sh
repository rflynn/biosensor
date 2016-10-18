#!/bin/bash

set -x

datestamp=$(date +%Y-%m-%d-%H-%M-%S)
year=${datestamp:0:4}
mon=${datestamp:5:2}
day=${datestamp:8:2}

destdir=./photos/$year/$mon/$day
destfile=$destdir/$datestamp.jpg

snapshot()
{
	# NOTE: -q 10 gives us quality=75. weird scale...
	# NOTE: -q 11 gives us quality=80. weird scale...
	# NOTE: -q 12 gives us quality=83. weird scale...
	raspistill -t 1 -w 512 -h 384 -q 12 --roi 0.25,0.25,0.5,0.5 -o $destfile
}

mkdir -p $destdir
snapshot
