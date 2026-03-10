import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientAuthProvider>(
      builder: (context, auth, _) {
        if (auth.isInitializing) {
          return const _SplashScreen();
        }

        if (!auth.isSignedIn) {
          return const LoginScreen();
        }

        // Any authenticated user can access the app
        return const DashboardScreen();
      },
    );
  }
}

// Keep old name as alias for compatibility
typedef AdminAuthWrapper = AuthWrapper;

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryPurple, AppColors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo3.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

