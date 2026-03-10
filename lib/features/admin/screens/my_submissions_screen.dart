import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';

class MySubmissionsScreen extends StatelessWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ClientAuthProvider>();
    final uid = auth.uid;

    if (uid == null) {
      return const Center(
        child: Text('Please sign in to view your submissions'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pending_products')
            .where('submittedBy', isEqualTo: uid)
            .orderBy('submittedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Check if it's an index error
            final errorStr = snapshot.error.toString();
            if (errorStr.contains('index')) {
              return _buildIndexError(errorStr);
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildSubmissionCard(
                context: context,
                id: doc.id,
                name: (data['name'] ?? 'Untitled').toString(),
                imageUrl: data['imageUrl']?.toString(),
                gender: (data['gender'] ?? '').toString(),
                ethnicity: (data['ethnicity'] ?? '').toString(),
                ageGroup: (data['ageGroup'] ?? '').toString(),
                status: (data['status'] ?? 'pending').toString(),
                submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIndexError(String errorStr) {
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
                color: AppColors.warningOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 40,
                color: AppColors.warningOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Setting Up...',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The database is being configured. Please try again in a few minutes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
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
              CupertinoIcons.doc_text,
              size: 44,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Submissions Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Post your first ad to get started',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard({
    required BuildContext context,
    required String id,
    required String name,
    required String? imageUrl,
    required String gender,
    required String ethnicity,
    required String ageGroup,
    required String status,
    required DateTime? submittedAt,
  }) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = AppColors.success;
        statusText = 'Approved';
        statusIcon = CupertinoIcons.checkmark_circle_fill;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'Rejected';
        statusIcon = CupertinoIcons.xmark_circle_fill;
        break;
      default:
        statusColor = AppColors.warningOrange;
        statusText = 'Pending Review';
        statusIcon = CupertinoIcons.clock_fill;
    }

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
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 180,
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
                        CupertinoIcons.photo,
                        size: 56,
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

          // Name
          if (name.isNotEmpty)
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          const SizedBox(height: 12),

          // Details
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
          const SizedBox(height: 12),

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
                submittedAt == null ? 'Just now' : _getTimeAgo(submittedAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
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
