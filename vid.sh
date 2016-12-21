#!/bin/bash

set -x


#raspivid -n -v -w 512 -h 384 -fps 2 -t 5000 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
#raspivid -n -v -w 1024 -h 768 -fps 2 -t 5000 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

# crummy quality
#raspivid -n -v -w 1024 -h 768 -fps 2 -t 5000 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

# pretty good
#raspivid -n -v -fps 2 -t 10000 --roi 0.25,0.25,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

# ok
#raspivid -n -v -fps 2 -t 10000 -b 1000000 --roi 0.25,0.25,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

# ok, smaller
#raspivid -n -v -fps 2 -t 30000 -b 500000 --roi 0.25,0.25,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# 1.8MB

# fps=2 ok
raspivid -n -v -fps 2 -t 60000 -b 500000 --roi 0.25,0.25,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# 3.6MB

# fps=1 fucks up and looks green. why?
#raspivid -n -v -fps 1 -t 60000 -b 500000 --roi 0.25,0.25,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

# fps=2 smaller size... poor resolution
#raspivid -n -v -fps 2 -t 60000 -b 500000 -w 1280 -h 768 --roi 0.25,0.375,0.50,0.50 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# 3.7MB

# fps=2 smaller size
#raspivid -n -v -fps 2 -t 60000 -b 1000000 -w 512 -h 384 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# 912KB great. a little small and little pixelated, but this might work for actual monitoring...

# fps=2 smaller size
#raspivid -n -v -fps 2 -t 60000 -b 2000000 -w 512 -h 384 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# shit

# fps=2 looks ok
raspivid -n -v -fps 2 -t 60000 -b 1000000 -w 1024 -h 768 --roi 0.375,0.375,0.25,0.25 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4
# ?MB


# good, but too big
#raspivid -n -v -fps 2 -t 10000 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$(date +%Y-%m-%d-%H-%M-%S).mp4

exit 0


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
	#raspistill -t 1 -w 512 -h 384 -q 13 --roi 0.25,0.25,0.5,0.5 -o $destfile
	raspistill -t 1 -w 512 -h 384 -q 12 --roi 0.375,0.375,0.25,0.25 -o $destfile  # ok...
}

mkdir -p $destdir
snapshot
