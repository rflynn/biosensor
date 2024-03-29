#!/bin/bash
test -d venv2.7 || virtualenv --system-site-packages -p python2.7 venv2.7
source venv2.7/bin/activate
pip install --upgrade pip
pip install scipy
pip install Pillow
pip install numpy
#pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.11.0rc0-py3-none-any.whl
pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.11.0rc0-py2-none-any.whl
python train.py --hypes data/classify-cat/main.json --gpu 0 --logdir output
