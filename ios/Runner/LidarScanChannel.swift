import Flutter
import ARKit

/// Flutter MethodChannel handler for LiDAR scanning.
class LidarScanChannel: NSObject {
    private let registrar: FlutterPluginRegistrar
    private let rootViewController: FlutterViewController
    private var channel: FlutterMethodChannel?

    init(registrar: FlutterPluginRegistrar, rootViewController: FlutterViewController) {
        self.registrar = registrar
        self.rootViewController = rootViewController
        super.init()
    }

    func register() {
        channel = FlutterMethodChannel(name: "holobox/lidar", binaryMessenger: registrar.messenger())
        channel?.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            result(isLidarSupported())
        case "startScan":
            startScan(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func isLidarSupported() -> Bool {
        if #available(iOS 13.4, *) {
            return ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        }
        return false
    }

    private func startScan(result: @escaping FlutterResult) {
        guard isLidarSupported() else {
            result(FlutterError(code: "UNSUPPORTED", message: "LiDAR not available", details: nil))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let scannerVC = LidarScannerViewController()
            scannerVC.modalPresentationStyle = .fullScreen
            scannerVC.onComplete = { objPath in
                self.rootViewController.dismiss(animated: true) {
                    if let path = objPath {
                        result(path)
                    } else {
                        result(FlutterError(code: "CANCELLED", message: "Scan cancelled", details: nil))
                    }
                }
            }
            self.rootViewController.present(scannerVC, animated: true)
        }
    }
}
