# vim: set ts=4 et:
from datetime import datetime
import os
import time

import picamera

# ref: http://picamera.readthedocs.io/en/release-1.12/api_camera.html

with picamera.PiCamera() as camera:
    camera.resolution = (600, 450)
    #camera.framerate = 1
    camera.zoom = (0.375, 0.375, 0.25, 0.25)
    camera.sharpness = +10
    camera.awb_mode = 'auto'  # sunlight
    #camera.start_preview()
    #camera.start_recording('foo.h264')
    #camera.wait_recording(10)
    try:
        while True:
            dt = datetime.now()
            while dt.hour >= 7 and dt.hour < 18:
                dt = datetime.now()
                path = './photos/%04d/%02d/%02d' % (dt.year, dt.month, dt.day)
                try:
                    os.makedirs(path)
                except:
                    pass
                filedest = '%s/%04d-%02d-%02d-%02d-%02d-%02d.jpg' % (
		            path, dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second)
                print(filedest)
                camera.capture(filedest, format='jpeg', quality=12, thumbnail=None, bayer=False, use_video_port=False)
                time.sleep(1)
            print('%s hour=%02d, waiting...' % (dt, dt.hour))
            time.sleep(60)
    except Exception as e:
        print(e)
    #camera.wait_recording(10)
    #camera.stop_recording()
