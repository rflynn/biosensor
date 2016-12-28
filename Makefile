# vim: set ts=8 noet:

SHELL := /bin/bash

default:
	echo wut

install:
	sudo apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev
	sudo apt-get install -y gphoto2 imagemagick
	sudo apt-get install -y python-picamera python3-picamera
	sudo apt-get install -y libavcodec-extra libav-tools
	sudo apt-get install -y python-virtualenv python-pip python-dev python3-dev
	virtualenv --system-site-packages venv && venv/bin/pip install -r requirements.txt

install-service:
	sudo cp service/biosensor /etc/init.d/biosensor
	sudo update-rc.d biosensor defaults


snapshot:
	raspistill -t 1 -w 512 -h 384 -q 50 --roi 0.25,0.25,0.5,0.5 -o /tmp/image_$$(date +%Y-%m-%d-%H-%M-%S).jpg

snapshot-hq:
	raspistill -t 1 -w 1024 -h 768 -q 75 --roi 0.25,0.25,0.5,0.5 -o /tmp/image_$$(date +%Y-%m-%d-%H-%M-%S).jpg

snapshot-bw:
	time raspistill --colfx 128:128 -t 1 -n -w 512 -h 384 -o /tmp/image.jpg

stream:
	which vlc || sudo apt-get install -y vlc
	raspivid -o - -t 0 -n -w 600 -h 400 -fps 3 | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264

webserve:
	(cd /tmp && python3 -m http.server 8081)

vid-tag-archive: FORCE
	tar -cJf vid-tag-$$(date +%Y-%m-%d).tar.xz vid-tag vid-tag-cropped

passport-sync: FORCE
	rsync -av --delete vid-tag-cropped/ /Volumes/PASSPORT/src/biosensor/vid-tag-cropped/
	rsync -av --delete vid-tag/ /Volumes/PASSPORT/src/biosensor/vid-tag/

vid-tag-sync: FORCE
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --delete --exclude .DS_Store bestof/ s3://biosensor-vid/bestof/
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --delete --exclude .DS_Store vid-tag/_negative/ s3://biosensor-vid/vid-tag-negative/
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --size-only --delete --exclude .DS_Store vid-tag-cropped/ s3://biosensor-vid/vid-tag-cropped/

vid-tag-sync-pull: FORCE
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --delete s3://biosensor-vid/bestof/ bestof/
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --delete s3://biosensor-vid/vid-tag-negative/ vid-tag-negative/
	AWS_ACCESS_KEY_ID=AKIAJ7SHC5IHG3HLRWNA AWS_SECRET_ACCESS_KEY=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 aws s3 sync --delete s3://biosensor-vid/vid-tag-cropped/ vid-tag-cropped/

vid-tag-cropped-count: FORCE
	find vid-tag-cropped -name '*.jpg' | grep -Eo '/[^/]+/' | sed -e's/\///g' | sort | uniq -c | sort -k1 -rn

vid-tag-count-jpg-xml: FORCE
	find vid-tag -name '*.jpg' -o -name '*.xml' | sed -e's/^vid-tag\///' -e's/\/20.*[.]/ /' | sort | uniq -c | sort -k1 -rn

venv:
	test -d venv || virtualenv --system-site-packages -p python2.7 venv # inherit cv2 from global...
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

