import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+1 234 567 8900');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
          'Account Settings',
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
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      size: 50,
                      color: AppColors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change profile picture')),
                        );
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(
                          CupertinoIcons.camera,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Full Name
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: CupertinoIcons.person,
            ),
            const SizedBox(height: 16),
            // Email
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: CupertinoIcons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Phone
            _buildTextField(
              controller: _phoneController,
              label: 'Phone',
              icon: CupertinoIcons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            // Save Button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully!'),
                    backgroundColor: AppColors.primaryPurple,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Change Password
            _buildActionButton(
              icon: CupertinoIcons.lock,
              title: 'Change Password',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password - Coming soon')),
                );
              },
            ),
            const SizedBox(height: 12),
            // Delete Account
            _buildActionButton(
              icon: CupertinoIcons.delete,
              title: 'Delete Account',
              textColor: AppColors.error,
              onTap: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.textSecondary.withOpacity(0.6),
                size: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryPurple,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.textDark,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: textColor ?? AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion requested'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
