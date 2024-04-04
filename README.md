A new Flutter application to demonstrate how to implement flutter google maps in a flutter application and implement routing.

## Plugins

The plugins used in this project are:

* [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
* [geolocator](https://pub.dev/packages/geolocator)
* [flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points)
* [geocoding](https://pub.dev/packages/geocoding)
* [location](https://pub.dev/packages/location)
* [permission_handler](https://pub.dev/packages/permission_handler)

## Adding Map To the App

1. Get an API key at https://cloud.google.com/maps-platform/.

2. Enable Google Map SDK for each platform.
   - Go to [Google Developers Console.](https://console.cloud.google.com/)
   - Choose the project that you want to enable Google Maps on.
   - Select the navigation menu and then select "Google Maps".
   - Select "APIs" under the Google Maps menu.
   - To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
   - To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
   - Make sure the APIs you enabled are under the "Enabled APIs" section.

3. In `android/app/src/main/AndroidManifest.xml` inside `Application tag` add your key
```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

4. In `ios/Runner/AppDelegate.swift` add the following lines
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
5. Use the `GoogleMapsWidget.dart` inside the `lib/widget` folder as normal widget and use it where you want.


### Customizing the markers

1. Declare a BitmapDescriptor which will hold the customIcon
```dart
late BitmapDescriptor customIcon;
```

2. Inside **initState()** Assign the needed png to the **customIcon**
```dart
@override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    super.initState();
  }
```

3. Finally add the **customIcon** to the marker
```dart
Marker(
     markerId: MarkerId(markerLocation.toString()),
     position: markerLocation,
     icon: customIcon,
   )
```

### Activating Directions API
1. Go to [Google Developers Console.](https://console.cloud.google.com/)
2. Choose the project that you want to enable Google Maps on.
3. Select the navigation menu and then select "Google Maps".
4. Select "APIs" under the Google Maps menu.
5. Enable Google Directions, select "Directions API" in the "Additional APIs" section, then select "ENABLE".
6. Make sure the APIs you enabled are under the "Enabled APIs" section.
 

