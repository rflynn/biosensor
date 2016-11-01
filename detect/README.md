

## Archives
* https://s3.amazonaws.com/biosensor-vid/vid-tag-2016-10-17.tar.xz

## Image Labeling

* https://github.com/tzutalin/labelImg -- best so far, supports rect + custom label + multi-file
* https://github.com/cvhciKIT/sloth -- nice, but only allows rectangle and face annotations. hackable w/ Python... maybe
* https://github.com/mpitid/pylabelme -- most promising, does arbitrary labels, but only does free-hand polygon (not rect) and is one-file-at-a-time
* https://github.com/sanchom/pilab-annotator -- does multi-file, but is just broken


# Training a Haar Classifier

## Steps

## References
* http://coding-robin.de/2013/07/22/train-your-own-opencv-haar-classifier.html
    * http://www.technolabsz.com/2011/08/how-to-do-opencv-haar-training.html
    * http://note.sonots.com/SciSoftware/haartraining.html#w0a08ab4
    * http://docs.opencv.org/2.4/doc/user_guide/ug_traincascade.html?highlight=cascade%2520classifier%2520training

```
../venv/bin/python gen_vid_tag_cropped.py
```

1. collect positive images (1500 cropped)
  1. list positive image filepaths
2. do the same for negative images
3. opencv_createsamples?
3. generate .vec files (how? bin/createsamples.pl)
4. ~~merge .vec files~~  <-- NO ref: http://answers.opencv.org/question/55879/opencv-mergevec-haartraining-issues/
5. opencv_traincascade


    # extract frames
    ffmpeg -i vid_1476049436-cat.mp4 -r 24 vid_1476049436-cat-frame-%03d.jpg


[Audio Event Classification Using Deep Neural Networks](http://smartfp7.eu/sites/default/files/field/files/page/Audio_classification_IS13.v1.03.final_.pdf)

> 3.1 Audio features
> The speech files are divided into 5-second segments with 50%
> overlap. For each segment we extract a vector of 192 features
> as follow. The segment itself is divided into frames. Each
> frame has length of 46 milliseconds and there is 50% overlap
> between the frames. The first 64 features are the mean of the
> MFCC over the entire segment. The second set of 64 features
> is their standard deviation (STD). The last set of 64 features is
> calculated by first taking the STD of the log spectrum over the
> frame and then applying the Mel-spaced filter banks. This type
> of feature helps differentiate between smooth spectrum and
> spectrum with peaks (e.g. musical tones).
> This whole feature set was found to be the best after
> experimenting with several others, more conventional features.

> The current error rates are a bit high for practical use. The
> high correlation between the different classifiers suggests that
> the main problem is not the classification technique.
> Additional improvement would require better features. We
> would probably need some features that can better describe
> the time dependencies in the signals. Another direction to
> improve the results would be to integrate the output from
> several segments.

