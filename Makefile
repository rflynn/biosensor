# ex: set ts=8 noet:

SHELL := /bin/bash

default:
	echo wut

install:
	sudo apt-get install -y gphoto2 imagemagick
	sudo apt-get install -y python-picamera python3-picamera
	sudo apt-get install -y libavcodec-extra libav-tools
	sudo apt-get install -y python-virtualenv python-pip
	virtualenv venv && venv/bin/pip install -r requirements.txt


snapshot:
	#fswebcam --no-banner -r 640x480 /tmp/image.jpg
	# default raspi NOIR camera resolution: 3280x2464
	# raspistill -o /tmp/image.jpg (5 seconds, 4174086 bytes)
	#time raspistill -t 1 -n -w 512 -h 384 -o /tmp/image.jpg
	#raspistill -w 1024 -h 768 -o /tmp/image.jpg
	#raspistill -w 1024 -h 768 --roi 0.25,0.25,0.5,0.5 -o /tmp/image.jpg
	#raspistill -t 1 -w 1024 -h 768 --roi 0.25,0.25,0.5,0.5 -o /tmp/image.jpg
	#raspistill -t 1 -w 512 -h 384 --roi 0.25,0.25,0.5,0.5 -o /tmp/image_$$(date +%Y-%m-%d-%H-%M-%S).jpg
	raspistill -t 1 -w 512 -h 384 -q 50 --roi 0.25,0.25,0.5,0.5 -o /tmp/image_$$(date +%Y-%m-%d-%H-%M-%S).jpg

snapshot-hq:
	raspistill -t 1 -w 1024 -h 768 -q 75 --roi 0.25,0.25,0.5,0.5 -o /tmp/image_$$(date +%Y-%m-%d-%H-%M-%S).jpg

snapshot-bw:
	time raspistill --colfx 128:128 -t 1 -n -w 512 -h 384 -o /tmp/image.jpg

timelapse:
	# time raspistill --colfx 128:128 --verbose -t 100000 -tl 5000 -n -w 512 -h 384 -o /tmp/img_%04d.jpg
	# 1fps for 60 seconds
	# raspivid --colfx 128:128 --verbose -w 512 -h 384 -fps 1 -t 10000 -o /tmp/vid.h264
	# convert raw H264 to MP4
	# sudo apt-get install -y libav-tools
	# avconv -y -r 1 -i /tmp/vid.h264 -vcodec copy /tmp/vid.mp4
	# record 1 minute @ 1fps to h264/mp4
	#raspivid --colfx 128:128 --verbose -w 512 -h 384 -fps 1 -t 60000 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$$(date +%s).mp4
	#raspivid --verbose -w 512 -h 384 -fps 1 -t 10000 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$$(date +%s).mp4
	#raspivid --verbose -w 512 -h 384 -fps 1 -t 10000 -o /tmp/vid_$$(date +%s).h264
	#raspivid -fps 1 -t 10000 -o /tmp/vid_$$(date +%s).h264
	#raspivid --verbose -w 512 -h 384 -fps 1 -t 10000 --roi 0.25,0.25,0.5,0.5 -o - | avconv -y -r 1 -i - -an -c:v copy /tmp/vid_$$(date +%Y-%m-%d).mp4
	#raspivid -n -v -ex auto -w 512 -h 384 -ss 100000 -fps 1 -t 10000 --roi 0.25,0.25,0.5,0.5 -o - | avconv -y -r 1 -i - -an -vcodec copy /tmp/vid_$$(date +%Y-%m-%d-%H-%M-%S).mp4
	raspivid -n -v --codec H264 -w 512 -h 384 -fps 1 -t 10000 --roi 0.25,0.25,0.5,0.5 -o - | avconv -y -r 1 -i - -vcodec copy /tmp/vid_$$(date +%Y-%m-%d-%H-%M-%S).mp4

stream:
	which vlc || sudo apt-get install -y vlc
	raspivid -o - -t 0 -n -w 600 -h 400 -fps 3 | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264

webserve:
	(cd /tmp && python3 -m http.server 8081)

vid-tag-archive: FORCE
	tar -cJf vid-tag-$$(date +%Y-%m-%d).tar.xz vid-tag

vid-test-archive: FORCE
	tar -cJf vid-test-$$(date +%Y-%m-%d).tar.xz vid-test

venv:
	virtualenv --system-site-packages -p python2.7 venv # inherit cv2 from global...
	./venv/bin/pip install -r requirements.txt

tmpramdrive:
	grep /tmp /etc/fstab || sudo sh -c 'echo "tmpfs    /tmp    tmpfs    defaults,noatime,nosuid,size=100m    0 0" >> /etc/fstab';
	grep /tmp <(mount) || sudo mount /tmp

tmpramdrive-modela:
	grep /tmp /etc/fstab || sudo sh -c 'echo "tmpfs    /tmp    tmpfs    defaults,noatime,nosuid,size=64m    0 0" >> /etc/fstab';
	grep /tmp <(mount) || sudo mount /tmp


# ref: http://blog.miguelgrinberg.com/post/how-to-build-and-run-mjpg-streamer-on-the-raspberry-pi

mjpg-streamer: mjpg-streamer-code-182
	$(MAKE) -C mjpg-streamer-r63/

mjpg-streamer-code-182: mjpg-streamer-code-182.zip
	unzip mjpg-streamer-code-182.zip

mjpg-streamer-code-182.zip:
	curl -L -O http://sourceforge.net/code-snapshots/svn/m/mj/mjpg-streamer/code/mjpg-streamer-code-182.zip

/usr/include/linux/videodev.h:
	sudo apt-get install -y libjpeg8-dev imagemagick libv4l-dev
	sudo ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h

FORCE:

.PHONY: install tmpfs mjpg-streamer

