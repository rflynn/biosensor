# vim: set ts=4 et:

'''
record a stream of high-quality snapshots to memory once per second
if moton is detected, record snapshots to disk
implement motion detection via H264 motion vectors
'''

from datetime import datetime
import io
import os
import time

import picamera

# ref: http://picamera.readthedocs.io/en/release-1.12/recipes2.html#recording-motion-vector-data
# ref: http://picamera.readthedocs.io/en/release-1.12/api_camera.html


def camera_init(camera):
    camera.resolution = (600, 450)
    #camera.framerate = 1
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
    filedest = '%s/%04d-%02d-%02d-%02d-%02d-%02d.jpg' % (
        path, dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second)
    print(filedest)
    with open(filedest, 'wb') as f:
        f.write(image)

def image_should_save(image):
    dt = datetime.now()
    return dt.hour >= 7 and dt.hour < 17

def image_capture(camera):
    stream = io.BytesIO()
    camera.capture(stream, format='jpeg', quality=12, thumbnail=None, bayer=False, use_video_port=False)
    stream.seek(0)
    return stream.read()

with picamera.PiCamera() as camera:
    camera_init(camera)
    #camera.start_preview()
    #camera.start_recording('foo.h264')
    #camera.wait_recording(10)
    try:
        while True:
            image = image_capture(camera)
            if image_should_save(image):
                image_write_to_disk(image)
            time.sleep(1)
    except Exception as e:
        print(e)
    #camera.wait_recording(10)
    #camera.stop_recording()
