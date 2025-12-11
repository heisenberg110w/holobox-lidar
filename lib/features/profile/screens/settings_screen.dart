import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _promotionalEmails = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive email notifications',
              value: _emailNotifications,
              onChanged: (val) => setState(() => _emailNotifications = val),
            ),
            _buildSwitchTile(
              title: 'Promotional Emails',
              subtitle: 'Receive offers and promotions',
              value: _promotionalEmails,
              onChanged: (val) => setState(() => _promotionalEmails = val),
            ),
            const SizedBox(height: 24),
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              title: 'Dark Mode',
              subtitle: 'Enable dark theme',
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              title: 'Terms of Service',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms of Service')),
                );
              },
            ),
            _buildInfoTile(
              title: 'Privacy Policy',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy')),
                );
              },
            ),
            _buildInfoTile(
              title: 'App Version',
              trailing: '1.0.0',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: AppColors.primaryPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            else
              const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
