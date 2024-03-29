# ref: http://www.pyimagesearch.com/2015/05/25/basic-motion-detection-and-tracking-with-python-and-opencv/

# import the necessary packages
import argparse
import datetime
import imutils
import numpy as np
import time
import cv2

'''
curl -o http://192.168.1.207:8081/image_00[00-20].jpg
ffmpeg -r 1 -f image2 -s 512x384 -i 'img_%4d.jpg' -vcodec libx264 -crf 25 -pix_fmt yuv420p img.mp4
../../venv/bin/python motion_detector.py --video img.mp4

ffmpeg -r 1 -f image2 -s 512x384 -i 'x%4d.jpg' -vcodec libx264 -crf 25 -pix_fmt yuv420p x.mp4
../../venv/bin/python motion_detector.py --video x.mp4
'''

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-v", "--video", help="path to the video file")
ap.add_argument("-a", "--min-area", type=int, default=50, help="minimum area size")
ap.add_argument("-x", "--max-area", type=int, default=5000, help="maximum area size")
args = vars(ap.parse_args())

# if the video argument is None, then we are reading from webcam
if args.get('video') is None:
    camera = cv2.VideoCapture(0)
    time.sleep(0.25)
# otherwise, we are reading from a video file
else:
    camera = cv2.VideoCapture(args["video"])


#########

# calculate the average background
# skip first 3 seconds
for _ in range(24 * 3):
    (grabbed, frame) = camera.read()

avg1 = np.float32(frame)
while True:
    grabbed, frame = camera.read()
    if not grabbed:
        break
    #frame = imutils.resize(frame, width=500)
    cv2.accumulateWeighted(frame, avg1, 0.01)
    res1 = cv2.convertScaleAbs(avg1)

'''
OpenCV Error: Assertion failed (dst.size == src.size && dst.channels() == cn) in accumulateWeighted, file /tmp/opencv-20160604-38092-6muj0l/opencv-2.4.13/modules/imgproc/src/accum.cpp, line 430
Traceback (most recent call last):
  File "motion_detector.py", line 49, in <module>
    cv2.accumulateWeighted(frame, avg1, 0.01)
cv2.error: /tmp/opencv-20160604-38092-6muj0l/opencv-2.4.13/modules/imgproc/src/accum.cpp:430: error: (-215) dst.size == src.size && dst.channels() == cn in function accumulateWeighted
'''

#########

# re-open
camera = cv2.VideoCapture(args["video"])
# skip first 3 seconds
for _ in range(24 * 3):
    (grabbed, frame) = camera.read()

firstFrame = res1

# loop over the frames of the video
while True:
    # grab the current frame and initialize the occupied/unoccupied
    # text
    (grabbed, frame) = camera.read()
    text = "Unoccupied"

    # if the frame could not be grabbed, then we have reached the end
    # of the video
    if not grabbed:
        break

    # resize the frame, convert it to grayscale, and blur it
    #frame = imutils.resize(frame, width=500)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)

    # if the first frame is None, initialize it
    if firstFrame is None:
        firstFrame = gray
        continue
    # compute the absolute difference between the current frame and
    # first frame
    frameDelta = cv2.absdiff(firstFrame, gray)
    thresh = cv2.threshold(frameDelta, 25, 255, cv2.THRESH_BINARY)[1]

    '''
OpenCV Error: Sizes of input arguments do not match (The operation is neither 'array op array' (where arrays have the same size and the same number of channels), nor 'array op scalar', nor 'scalar op array') in arithm_op, file /tmp/opencv-20160604-38092-6muj0l/opencv-2.4.13/modules/core/src/arithm.cpp, line 1287
Traceback (most recent call last):
  File "motion_detector.py", line 93, in <module>
    frameDelta = cv2.absdiff(firstFrame, gray)
cv2.error: /tmp/opencv-20160604-38092-6muj0l/opencv-2.4.13/modules/core/src/arithm.cpp:1287: error: (-209) The operation is neither 'array op array' (where arrays have the same size and the same number of channels), nor 'array op scalar', nor 'scalar op array' in function arithm_op
    '''

    # dilate the thresholded image to fill in holes, then find contours
    # on thresholded image
    thresh = cv2.dilate(thresh, None, iterations=2)
    (cnts, _) = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE)

    # loop over the contours
    for c in cnts:
        # if the contour is too small, ignore it
        if cv2.contourArea(c) < args["min_area"]:
            continue
        if cv2.contourArea(c) > args["max_area"]:
            continue

        # compute the bounding box for the contour, draw it on the frame,
        # and update the text
        (x, y, w, h) = cv2.boundingRect(c)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        text = "Occupied"
    # draw the text and timestamp on the frame
    cv2.putText(frame, "Room Status: {}".format(text), (10, 20),
        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
    cv2.putText(frame, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),
        (10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)

    # show the frame and record if the user presses a key
    cv2.imshow("Security Feed", frame)  # boxes
    # cv2.imshow("Thresh", thresh)  # hard edge threshold
    #cv2.imshow("Frame Delta", frameDelta)  # heat-area type vis

    key = cv2.waitKey() & 0xFF
    print(key)

    # if the `q` key is pressed, break from the loop
    if key == ord('q'):
        break

# cleanup the camera and close any open windows
camera.release()
cv2.destroyAllWindows()
