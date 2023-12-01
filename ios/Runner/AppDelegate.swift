import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("AIzaSyBQ8DQZN86S4AzW6pHggU7JmbbhkL_5Bfo")
    GeneratedPluginRegistrant.register(with: self)
      
      if #available(iOS 10.0, *) {
           UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          }
         
       application.registerForRemoteNotifications()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
