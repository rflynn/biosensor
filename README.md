
## Run

    make tmpramdrive
    make snapshot
    make webserve


## Install



## Design

1. Hardware. Output: photo/video/audio stream
2. Object detection/classification
3. Sharing/reporting


## Hardware

...

* http://sonof8bits.com/automated-raspberry-pi-audio-recorder/2014/09 -- record audio using sox, and pause/stop on silence.
* http://baddotrobot.com/blog/2016/01/06/disable-led-for-edimax/
* http://shallowsky.com/blog/hardware/raspberry-pi-noir.html
* https://picamera.readthedocs.io/en/release-1.12/recipes2.html

```sh
echo disable_camera_led=1 >> /boot/config.txt
```
ref: http://shallowsky.com/blog/hardware/raspberry-pi-noir.html


## Detection/Classification

### Images/Video

How do we identify stuff?

* http://www.pyimagesearch.com/2015/05/25/basic-motion-detection-and-tracking-with-python-and-opencv/
* http://shallowsky.com/blog/linux/install/simplecv-on-rpi.html
* https://github.com/Russell91/TensorBox
* http://www.pyimagesearch.com/2016/06/20/detecting-cats-in-images-with-opencv/
* [OpenCV Tutorial: Training your own detector | packtpub.com](https://www.youtube.com/watch?v=WEzm7L5zoZE)
* https://github.com/samjabrahams/tensorflow-on-raspberry-pi


### Audio

How does one detect bird calls in an audio file?

1. https://humblesoftwaredev.wordpress.com/2016/05/02/an-audio-dataset-and-ipython-notebook-for-training-a-convolutional-neural-network-to-distinguish-the-sound-of-foosball-goals-from-other-noises-using-tensorflow/
    1. https://github.com/dk1027/ConvolutionalNeuralNetOnFoosballSounds
2. https://www.lunaverus.com/cnn
3. https://www.kaggle.com/c/mlsp-2013-birds
4. http://stackoverflow.com/questions/22471072/convolutional-neural-network-cnn-for-audio


## Sharing/Reporting

...


# References

1. http://www.makeuseof.com/tag/raspberry-pi-camera-module/
2. http://simplecv.org/
3. https://web.wpi.edu/Pubs/E-project/Available/E-project-042910-001603/unrestricted/Bird_Call_Identification_MQP_2010.pdf
4. http://csgrid.org/csg/wildlife/
5. http://www.xeno-canto.org/explore/region
6. https://en.wikipedia.org/wiki/Bioacoustics
7. http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/

