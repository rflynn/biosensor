import picamera
# import time

with picamera.PiCamera() as camera:
    # camera.start_preview()
    # time.sleep(0)
    camera.capture('/tmp/image.jpg')
    # camera.stop_preview()
