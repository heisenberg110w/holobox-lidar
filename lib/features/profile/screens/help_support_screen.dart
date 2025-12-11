import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Help & Support',
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
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactTile(
              icon: CupertinoIcons.mail,
              title: 'Email Support',
              subtitle: 'support@holobox.com',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email app...')),
                );
              },
            ),
            _buildContactTile(
              icon: CupertinoIcons.phone,
              title: 'Phone Support',
              subtitle: '+1 (800) 123-4567',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling support...')),
                );
              },
            ),
            _buildContactTile(
              icon: CupertinoIcons.chat_bubble_2,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening chat...')),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'FAQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQTile(
              question: 'How do I track my order?',
              answer: 'You can track your order from Order History section.',
            ),
            _buildFAQTile(
              question: 'What is the return policy?',
              answer: '30-day hassle-free returns on all products.',
            ),
            _buildFAQTile(
              question: 'How long does delivery take?',
              answer: 'Standard delivery takes 3-5 business days.',
            ),
            _buildFAQTile(
              question: 'Do you offer international shipping?',
              answer: 'Yes, we ship to over 50 countries worldwide.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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

  Widget _buildFAQTile({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
