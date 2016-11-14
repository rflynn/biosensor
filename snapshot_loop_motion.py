#!/usr/bin/python
# vim: set ts=4 et:

from datetime import datetime
import io
import logging
import numpy as np
import os
import picamera
import picamera.array
import signal
from time import sleep


logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')
LOG = logging.getLogger('capture_motion')

def signal_term_handler(signal, frame):
    LOG.info('shutting down ...')
    # this raises SystemExit(0) which fires all "try...finally" blocks:
    sys.exit(0)

# this is useful when this program is started at boot via init.d
# or an upstart script, so it can be killed: i.e. kill some_pid:
signal.signal(signal.SIGTERM, signal_term_handler)

def camera_init(camera):
    camera.resolution = (640, 480)
    camera.framerate = 4
    camera.zoom = (0.375, 0.375, 0.25, 0.25)
    camera.sharpness = +5
    camera.awb_mode = 'auto'  # sunlight
    LOG.info('camera.shutter_speed=%s...' % camera.shutter_speed)

def ensure_dir(path):
    try:
        os.makedirs(path)
    except Exception as e:
        print(e)

def image_calc_filename():
    dt = datetime.now()
    path = './photos/%04d/%02d/%02d' % (dt.year, dt.month, dt.day)
    filename = '%s/%04d-%02d-%02d-%02d-%02d-%02d-%03d.jpg' % (
        path, dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, int(dt.microsecond / 1000))
    return path, filename

def image_write_to_disk(image):
    path, filename = image_calc_filename()
    LOG.info('writing...')
    try:
        with open(filename, 'wb') as f:
            f.write(image)
    except Exception as e:
        print(e)
        ensure_dir(path)
        try:
            with open(filename, 'wb') as f:
                f.write(image)
        except Exception as e2:
            print(e2)
    LOG.info('written')
    return filename

def image_should_save(image):
    dt = datetime.now()
    return dt.hour >= 7 and dt.hour < 17

def image_capture(camera):
    stream = io.BytesIO()
    LOG.info('capture...')
    camera.capture(stream, format='jpeg', quality=12, thumbnail=None, bayer=False, use_video_port=False)
    LOG.info('captured')
    stream.seek(0)
    return stream.read()

def _image_capture_burst(camera):
    stream = io.BytesIO()
    i = 0
    # NOTE: burst= may or may not be helpful...
    for _ in camera.capture_continuous(stream, format='jpeg', quality=12, burst=False, thumbnail=None, bayer=False, use_video_port=False):
        stream.truncate()
        stream.seek(0)
        filename = image_write_to_disk(stream.read())
        LOG.info('image_capture_burst filename: %s %s' % (i, filename))
        if i >= 1:
            break
        i += 1
    return filename

def image_capture_burst(camera):
    for i in range(2):
        image = image_capture(camera)
        filename = image_write_to_disk(image)
        LOG.info('image_capture_burst filename: %s %s' % (i, filename))
    return filename

def on_motion_detection(camera):
    # when motion is detected, take a series of snapshots
    filename = image_capture_burst(camera)
    # LOG.info('image captured to file: %s' % filename)


minimum_still_interval = 5
motion_detected = False
last_still_capture_time = datetime.now()

# The 'analyse' method gets called on every frame processed while picamera
# is recording h264 video.
# It gets an array (see: "a") of motion vectors from the GPU.
class DetectMotion(picamera.array.PiMotionAnalysis):
    def analyse(self, a):
        global motion_detected
        # print('analyse...')
        #if datetime.datetime.now() > last_still_capture_time + \
        #    datetime.timedelta(seconds=minimum_still_interval):
        a = np.sqrt(
            np.square(a['x'].astype(np.float)) +
            np.square(a['y'].astype(np.float))
        ).clip(0, 255).astype(np.uint8)
        # experiment with the following "if" as it may be too sensitive ???
        # if there're more than 10 vectors with a magnitude greater
        # than 60, then motion was detected:
        mo = (a > 10).sum()
        if mo > 1:
            is_mo = 7 <= mo < 500
            LOG.info('motion: %s%s' % (mo, '*' if is_mo else ''))
            if is_mo:
                # higher threshold is to avoid detecting motion every time we start...
                motion_detected = True

camera = picamera.PiCamera()
with DetectMotion(camera) as output:
    try:
        camera_init(camera)
        # record video to nowhere, as we are just trying to capture images:

        while True:
            camera.start_recording('/dev/null',
                                   format='h264',
                                   motion_output=output)

            LOG.info('waiting for motion...')
            while not motion_detected:
                camera.wait_recording(0)  # no wait
                sleep(0.0625)

            LOG.info('stop recording and capture an image...')
            camera.stop_recording()
            motion_detected = False

            on_motion_detection(camera)

    except KeyboardInterrupt as e:
        LOG.info("\nreceived KeyboardInterrupt via Ctrl-C")
        pass
    finally:
        camera.close()
        LOG.info("\ncamera turned off!")
        LOG.info("detect motion has ended.\n")
