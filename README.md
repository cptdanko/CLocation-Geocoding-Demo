# CLocation-Geocoding-Demo

This is a simple Xcode project that demonstrates how to decouple location based functionality from the ViewController of an iOS app. More specifically how to seggragate location based features from any UIKit based code. 

In this example, you can get the ViewController user's location from CoreLocation as well as the actual address of the GPS coordinates via ReverseGeocoding without a single import of the CoreLocation in the UIViewController class.

This is achieved with the user of Swift protocol, the delegate pattern and completion handlers.

