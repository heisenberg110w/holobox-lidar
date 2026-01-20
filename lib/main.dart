import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'features/admin/providers/admin_auth_provider.dart';
import 'features/admin/screens/admin_auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS will typically rely on `GoogleService-Info.plist` (no options needed).
  // Android uses `firebase_options.dart` (already configured).
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    await Firebase.initializeApp();
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const HoloboxAdminApp());
}

class HoloboxAdminApp extends StatelessWidget {
  const HoloboxAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminAuthProvider()..init(),
      child: MaterialApp(
        title: 'Holobox Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AdminAuthWrapper(),
      ),
    );
  }
}

