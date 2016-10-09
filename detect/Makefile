# ex: set ts=8 noet:

SHELL := /bin/bash

default:
	echo default

install_dataset_Caltech_UCSD_Birds_200:
	curl -L -C - -O http://www.vision.caltech.edu/visipedia-data/CUB-200/images.tgz

install_tensorflow:
	[[ -d venv ]] || virtualenv -p python3 venv
	venv/bin/pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0rc0-cp35-cp35m-linux_x86_64.whl

install_tensorflow_osx:
	[[ -d venv ]] || virtualenv -p python3 venv
	venv/bin/pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.11.0rc0-py3-none-any.whl

install_facedetect:
	curl -L -O https://raw.githubusercontent.com/shantnu/FaceDetect/master/face_detect.py
	# TODO: have to flag=0 on cv2.cv.XXX
	curl -vL -s -O http://stash.compciv.org/opencv/haarcascades/haarcascade_frontalface_default.xml
