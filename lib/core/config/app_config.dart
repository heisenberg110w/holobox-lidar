class AppConfig {
  /// Force demo mode at runtime:
  /// `flutter run --dart-define=HOLOBOX_DEMO=true`
  static const bool forceDemo =
      bool.fromEnvironment('HOLOBOX_DEMO', defaultValue: false);
}

