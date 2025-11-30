import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: const Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
