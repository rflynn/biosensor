#!/bin/bash

# ref: http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/

set -xe
sudo apt-get install -y build-essential cmake git pkg-config
#sudo apt-get install -y libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev
sudo apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libatlas-base-dev gfortran

# not in the instructions but stuff i ran into...
sudo apt-get install -y python3.5-dev
sudo apt-get install -y libgphoto2-dev
sudo apt-get install -y libavformat-dev libavutil-dev

[[ -d cv ]] || virtualenv -p python3 cv
source cv/bin/activate
pip install numpy
[[ -d opencv ]] || git clone https://github.com/Itseez/opencv.git
(cd opencv && git checkout 3.0.0)
[[ -d opencv_contrib ]] || git clone https://github.com/Itseez/opencv_contrib.git
(cd opencv_contrib && git checkout 3.0.0)
cd opencv
[[ -d build ]] || mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
make -j4
sudo make install
sudo ldconfig
