# Hand-Timer-CoreML-Custom-Vision-ML-Model-iOS-Xcode

* Using Microsoft's Custom Vision "https://www.customvision.ai" I build a Core ML Model using hand images dataset of my own and created a model that can classify different hand gestures(static). It will get the image (input) from the custom camera feed in the iOS Application that i build and gives the output as the tag that was assigned to it while training. The hand can be Open Fist, Close Fist or there wont be a hand at all. It will classify between these 3 states.

* The application is a timer that has start stop reset functionality feature that will be controlled by your hand.

### How it works
- Give access to the Camera
- Place your hand in front of the back camera, you can see your hand with a little transparency in the background of the app.
- If you put your open fist in front of the camera, the timer will start or resume if you paused(next point) in middle.
- If you place closed fist in front of the camera, then the timer will be stopped or paused.
- If you take away your hand then the timer will be reset to 00:00.00

## Note
* Xcode 9 and Swift 4 was used for this project.
* The CoreML model for the hand detection is included in the project repository.

## How it looks like
(Gif)

![ezgif com-optimize](https://user-images.githubusercontent.com/15246084/41507647-1b027e54-7254-11e8-94c8-6c234f20ce40.gif)
