
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

* http://www.wildlifeacoustics.com/products/song-meter-sm4/faqs
* https://mannoiseandanimals.wordpress.com/2016/06/13/recording-stations/
* http://www.feedertweeter.net/about
* https://www.raspberrypi.org/blog/feeder-tweeter/
* http://www.mammalweb.org/
* http://spellfoundry.com/products/sleepy-pi-2/
* https://shop.pimoroni.com/products/mopi-mobile-pi-power

* http://sonof8bits.com/automated-raspberry-pi-audio-recorder/2014/09 -- record audio using sox, and pause/stop on silence.
* http://baddotrobot.com/blog/2016/01/06/disable-led-for-edimax/
* http://shallowsky.com/blog/hardware/raspberry-pi-noir.html
* https://picamera.readthedocs.io/en/release-1.12/recipes2.html

```sh
echo disable_camera_led=1 >> /boot/config.txt
```
ref: http://shallowsky.com/blog/hardware/raspberry-pi-noir.html

```sh
# echo bcm2708_wdog | sudo tee -a /etc/modules
sudo modprobe bcm2835_wdt
sudo apt-get install -y watchdog
sudo update-rc.d watchdog defaults
sudo /etc/init.d/watchdog start
vim /etc/watchdog.conf  # edit 'ping' lines...
```
ref: http://blog.ricardoarturocabral.com/2013/01/auto-reboot-hung-raspberry-pi-using-on.html


## Detection/Classification

### Images/Video

How do we identify stuff?

ref: https://www.quora.com/How-should-I-label-image-data-for-machine-learning
> How should I label image data for machine learning?
> Train a classifier on only some of the frames.
> Then write a program that uses the classifier to display the location of the car in a movie.
> Use that movie to find failure frames and fix the labels for some of those frames.
> Then retrain the classifier. Repeat this a few times and your classifier will be pretty good (if you use a good algorithm).

* http://coding-robin.de/2013/07/22/train-your-own-opencv-haar-classifier.html
* http://www.pyimagesearch.com/2015/05/25/basic-motion-detection-and-tracking-with-python-and-opencv/
* http://shallowsky.com/blog/linux/install/simplecv-on-rpi.html
* https://github.com/Russell91/TensorBox
* http://www.pyimagesearch.com/2016/06/20/detecting-cats-in-images-with-opencv/
* [OpenCV Tutorial: Training your own detector | packtpub.com](https://www.youtube.com/watch?v=WEzm7L5zoZE)
* https://github.com/samjabrahams/tensorflow-on-raspberry-pi
* https://realpython.com/blog/python/face-detection-in-python-using-a-webcam/
* http://www.bitfusion.io/2016/08/31/training-a-bird-classifier-with-tensorflow-and-tflearn/


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

