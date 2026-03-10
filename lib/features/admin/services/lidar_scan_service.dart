import 'package:flutter/services.dart';

/// Service to interact with native iOS LiDAR scanner via MethodChannel.
/// Returns null/throws on Android or unsupported iOS devices.
class LidarScanService {
  static const _channel = MethodChannel('holobox/lidar');

  /// Check if LiDAR scanning is supported on this device.
  /// Returns true only on iOS devices with LiDAR (iPhone 12 Pro+, iPad Pro 2020+).
  Future<bool> isSupported() async {
    try {
      final result = await _channel.invokeMethod<bool>('isSupported');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      // Expected on Android - LiDAR is iOS only
      return false;
    }
  }

  /// Start a LiDAR scan session.
  /// Returns the local file path to the exported OBJ file on success.
  /// Throws on failure or cancellation.
  Future<String?> startScan() async {
    try {
      final result = await _channel.invokeMethod<String>('startScan');
      return result;
    } on PlatformException catch (e) {
      throw Exception('LiDAR scan failed: ${e.message}');
    } on MissingPluginException {
      throw Exception('LiDAR not available on this platform');
    }
  }
}
