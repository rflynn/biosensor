
Archives
* https://s3.amazonaws.com/biosensor-vid/vid-tag-2016-10-13.tar.xz
* https://s3.amazonaws.com/biosensor-vid/vid-test-2016-10-13.tar.xz


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


    # extract frames
    ffmpeg -i vid_1476049436-cat.mp4 -r 24 vid_1476049436-cat-frame-%03d.jpg

