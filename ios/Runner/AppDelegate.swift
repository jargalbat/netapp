import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Custom code: Google firebase
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    
    // Custome code: Google map
    GMSServices.provideAPIKey("AIzaSyBNQIgNuKd0oxyoGsLNKNYUDf7z7GBAMGo")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
}
