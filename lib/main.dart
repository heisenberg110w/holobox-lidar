import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'features/admin/providers/admin_auth_provider.dart';
import 'features/admin/repositories/admin_repository.dart';
import 'features/admin/repositories/demo_admin_repository.dart';
import 'features/admin/repositories/firebase_admin_repository.dart';
import 'features/admin/screens/admin_auth_wrapper.dart';

Future<void> main() async {
  // Catch all errors in release mode
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    bool demoMode = AppConfig.forceDemo;
    String? initError;
    
    try {
      if (!demoMode) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      // If Firebase isn't configured, fall back to demo mode
      initError = e.toString();
      demoMode = true;
      try {
        await Firebase.initializeApp();
      } catch (_) {
        // Ignore: demo mode does not require Firebase.
      }
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Set up global error handling for Flutter errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // In release mode, log to console
        debugPrint('Flutter Error: ${details.exception}');
      }
    };

    runApp(HoloboxApp(demoMode: demoMode, initError: initError));
  }, (error, stack) {
    // Catch errors outside of Flutter framework
    debugPrint('Uncaught error: $error');
    debugPrint('Stack: $stack');
  });
}

class HoloboxApp extends StatelessWidget {
  final bool demoMode;
  final String? initError;
  const HoloboxApp({super.key, required this.demoMode, this.initError});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AdminRepository>(
          create: (_) => demoMode ? DemoAdminRepository() : FirebaseAdminRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientAuthProvider(demoMode: demoMode)..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Holobox',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        // Show errors in a user-friendly way
        builder: (context, child) {
          // Show init error if any (for debugging)
          if (initError != null && !kReleaseMode) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Init Error: $initError'),
                ),
              ),
            );
          }
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}

