import Flutter
import UIKit
import Purchases

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    // Initialize RevenueCat
    Purchases.configure(withAPIKey: "appl_cbQYiDPSmNYpFeRSQcJcjsbSHJJ")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
