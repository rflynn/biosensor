#!/bin/bash

set -xe -o pipefail

NPCU=$(nproc || getconf _NPROCESSORS_ONLN || echo 1)

sudo apt-get install -y build-essential cmake git

sudo apt-get install -y ffmpeg libopencv-dev libgtk-3-dev python-numpy python3-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libv4l-dev libtbb-dev qtbase5-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip

if [[ ! -d opencv-3.1.0 ]]; then
    [[ -f 3.1.0.zip ]] || curl -L -C - -O https://github.com/Itseez/opencv/archive/3.1.0.zip
    unzip 3.1.0.zip
fi

cd opencv-3.1.0
mkdir -p build && cd build
cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON \
    -D WITH_CUBLAS=ON \
    ..
make -j $NCPU
sudo make install

