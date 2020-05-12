import UIKit
import Flutter
import GoogleMaps
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
   func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any], open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]?
    )
    -> Bool {
    //Maps
        GMSServices.provideAPIKey("AIzaSyDMFGSvHB0MkQI3s3pNMOZ1Rsjk90R18Mg")
    //Maps
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    if #available(iOS 9.0, *) {
        _ = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options?[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options![UIApplication.OpenURLOptionsKey.annotation])
    } else {
        // Fallback on earlier versions
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


}

