import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register LiDAR scan channel for iOS
    if let controller = window?.rootViewController as? FlutterViewController,
       let registrar = self.registrar(forPlugin: "holobox_lidar") {
      LidarScanChannel(registrar: registrar, rootViewController: controller).register()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
