import UIKit
import Flutter
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //Maps
        GMSServices.provideAPIKey("AIzaSyDMFGSvHB0MkQI3s3pNMOZ1Rsjk90R18Mg")
    //Maps
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   @available(iOS 9.0, *)
  override  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,  open: url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
  }

    // para iOS menor a 9.0
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL!,sourceApplication: sourceApplication,annotation: annotation)
  }
}
