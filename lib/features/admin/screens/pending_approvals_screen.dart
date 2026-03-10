import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';
import '../repositories/admin_repository.dart';
import '../models/pending_product.dart';

class PendingApprovalsScreen extends StatelessWidget {
  const PendingApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: StreamBuilder<List<PendingProduct>>(
        stream: context.read<AdminRepository>().watchPendingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error);
          }

          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return _buildProductCard(
                context: context,
                id: p.id,
                name: p.name,
                imageUrl: p.imageUrl,
                gender: p.gender,
                ethnicity: p.ethnicity,
                ageGroup: p.ageGroup,
                submittedAt: p.submittedAt,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    final errorStr = error.toString();
    // Extract Firebase index creation URL from error message
    final uriMatch = RegExp(r'https://console\.firebase\.google\.com[^\s]+').firstMatch(errorStr);
    final indexUrl = uriMatch?.group(0);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Index Required',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Firestore needs a composite index to query pending products.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            if (indexUrl != null) ...[
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(indexUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.lightBlue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.link, color: AppColors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Create Index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'After creating the index, wait 2-5 minutes, then refresh.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  errorStr,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: const Icon(
              CupertinoIcons.checkmark_shield,
              size: 44,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No pending approvals at the moment',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required String id,
    required String name,
    required String? imageUrl,
    required String gender,
    required String ethnicity,
    required String ageGroup,
    required DateTime? submittedAt,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryPurple, AppColors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.cube_box,
                        size: 64,
                        color: AppColors.white,
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.photo,
                          size: 56,
                          color: AppColors.white,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          if (name.isNotEmpty) ...[
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Product Details
          Row(
            children: [
              _buildDetailChip(
                icon: CupertinoIcons.person,
                label: gender,
                color: AppColors.info,
              ),
              const SizedBox(width: 8),
              _buildDetailChip(
                icon: CupertinoIcons.globe,
                label: ethnicity,
                color: AppColors.warningOrange,
              ),
              const SizedBox(width: 8),
              _buildDetailChip(
                icon: CupertinoIcons.time,
                label: ageGroup,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Submitted time
          Row(
            children: [
              const Icon(
                CupertinoIcons.clock,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                submittedAt == null ? 'Pending' : _getTimeAgo(submittedAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _rejectProduct(context, id),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.error,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _approveProduct(context, id),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.lightBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.checkmark,
                          color: AppColors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Approve',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

Future<void> _approveProduct(BuildContext context, String id) async {
  final uid = context.read<AdminAuthProvider>().uid;
  if (uid == null) return;
  await context.read<AdminRepository>().approvePendingProduct(id: id, approvedBy: uid);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product approved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

Future<void> _rejectProduct(BuildContext context, String id) async {
  final uid = context.read<AdminAuthProvider>().uid;
  if (uid == null) return;
  await context.read<AdminRepository>().rejectPendingProduct(id: id, rejectedBy: uid);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product rejected'),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
