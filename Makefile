# ex: set ts=8 noet:

install:
	sudo apt-get install -y gphoto2 imagemagick
	sudo apt-get install -y python-picamera python3-picamera
	lsusb

snapshot:
	fswebcam --no-banner -r 640x480 /tmp/image.jpg

webserve:
	(cd /tmp && python3 -m http.server 8081)

tmpfs:
	grep /tmp /etc/fstb || sudo sh -c 'echo "tmpfs    /tmp    tmpfs    defaults,noatime,nosuid,size=100m    0 0" >> /etc/fstab'
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
