# ex: set ts=8 noet:

SHELL := /bin/bash

default:
	echo wut

install:
	sudo apt-get install -y gphoto2 imagemagick
	sudo apt-get install -y python-picamera python3-picamera

snapshot:
	#fswebcam --no-banner -r 640x480 /tmp/image.jpg
	# default raspi NOIR camera resolution: 3280x2464
	# raspistill -o /tmp/image.jpg (5 seconds, 4174086 bytes)
	# raspistill -w 1024 -h 768 -o /tmp/image.jpg
	time raspistill -t 1 -n -w 512 -h 384 -o /tmp/image.jpg

snapshot-bw:
	time raspistill --colfx 128:128 -t 1 -n -w 512 -h 384 -o /tmp/image.jpg

timelapse:
	time raspistill --colfx 128:128 --verbose -t 100000 -tl 5000 -n -w 512 -h 384 -o /tmp/img_%04d.jpg

stream:
	which vlc || sudo apt-get install -y vlc
	raspivid -o - -t 0 -n -w 600 -h 400 -fps 3 | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264

webserve:
	(cd /tmp && python3 -m http.server 8081)

venv:
	virtualenv --system-site-packages -p python2.7 venv # inherit cv2 from global...
	./venv/bin/pip install -r requirements.txt

tmpramdrive:
	grep /tmp /etc/fstab || sudo sh -c 'echo "tmpfs    /tmp    tmpfs    defaults,noatime,nosuid,size=100m    0 0" >> /etc/fstab';
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

.PHONY: install tmpfs mjpg-streamer
