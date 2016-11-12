#!/usr/bin/python
# vim: set ts=4 et:

from datetime import datetime
import io
import logging
import numpy as np
import picamera
import picamera.array
import signal


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
    camera.framerate = 5
    '''
    camera.resolution = (600, 450)
    #camera.framerate = 1
    '''
    camera.zoom = (0.375, 0.375, 0.25, 0.25)
    camera.sharpness = +5
    camera.awb_mode = 'auto'  # sunlight

def ensure_dir(path):
    try:
        os.makedirs(path)
    except:
        pass

def image_write_to_disk(image):
    dt = datetime.now()
    path = './photos/%04d/%02d/%02d' % (dt.year, dt.month, dt.day)
    ensure_dir(path)
    filedest = '%s/%04d-%02d-%02d-%02d-%02d-%02d-%03d.jpg' % (
        path, dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, int(dt.microsecond / 1000))
    with open(filedest, 'wb') as f:
        f.write(image)
    return filedest

def image_should_save(image):
    dt = datetime.now()
    return dt.hour >= 7 and dt.hour < 17

def image_capture(camera):
    stream = io.BytesIO()
    camera.capture(stream, format='jpeg', quality=12, thumbnail=None, bayer=False, use_video_port=False)
    stream.seek(0)
    return stream.read()

def on_motion_detection(camera):
    # when motion is detected, take a series of snapshots
    for n in range(3):
        image = image_capture(camera)
        filename = image_write_to_disk(image)
    LOG.info('image captured to file: %s' % filename)


minimum_still_interval = 5
motion_detected = False
last_still_capture_time = datetime.now()

# The 'analyse' method gets called on every frame processed while picamera
# is recording h264 video.
# It gets an array (see: "a") of motion vectors from the GPU.
class DetectMotion(picamera.array.PiMotionAnalysis):
    def analyse(self, a):
        global minimum_still_interval, motion_detected, last_still_capture_time
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
        if mo >= 10:
            LOG.info('motion: %s' % mo)
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
                camera.wait_recording(1)

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
