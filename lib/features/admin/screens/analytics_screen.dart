import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<ClientAuthProvider>();
    final uid = auth.uid;

    if (uid == null) {
      return const Center(
        child: Text('Please sign in to view analytics'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your ad performance',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Stats Cards
            _buildStatsSection(uid),

            const SizedBox(height: 24),

            // Approved Products Performance
            const Text(
              'Approved Ads Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildApprovedProductsList(uid),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pending_products')
          .where('submittedBy', isEqualTo: uid)
          .snapshots(),
      builder: (context, pendingSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('submittedBy', isEqualTo: uid)
              .snapshots(),
          builder: (context, approvedSnapshot) {
            int pendingCount = 0;
            int approvedCount = 0;
            int totalViews = 0;
            int totalSales = 0;

            if (pendingSnapshot.hasData) {
              pendingCount = pendingSnapshot.data!.docs.length;
            }

            if (approvedSnapshot.hasData) {
              approvedCount = approvedSnapshot.data!.docs.length;
              for (var doc in approvedSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                totalViews += (data['views'] ?? 0) as int;
                totalSales += (data['sales'] ?? 0) as int;
              }
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Pending',
                        value: pendingCount.toString(),
                        icon: CupertinoIcons.clock,
                        color: AppColors.warningOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Approved',
                        value: approvedCount.toString(),
                        icon: CupertinoIcons.checkmark_circle,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Total Views',
                        value: _formatNumber(totalViews),
                        icon: CupertinoIcons.eye,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Total Sales',
                        value: _formatNumber(totalSales),
                        icon: CupertinoIcons.cart,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedProductsList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('submittedBy', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Unable to load products',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.chart_bar,
                  size: 48,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No approved ads yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your approved ads will appear here with performance metrics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildProductAnalyticsCard(
              name: (data['name'] ?? 'Untitled').toString(),
              imageUrl: data['imageUrl']?.toString(),
              views: (data['views'] ?? 0) as int,
              sales: (data['sales'] ?? 0) as int,
              revenue: (data['revenue'] ?? 0.0).toDouble(),
            );
          },
        );
      },
    );
  }

  Widget _buildProductAnalyticsCard({
    required String name,
    required String? imageUrl,
    required int views,
    required int sales,
    required double revenue,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryPurple, AppColors.lightBlue],
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.photo,
                        color: AppColors.white,
                        size: 24,
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.lightBlue],
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.photo,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMiniStat(CupertinoIcons.eye, _formatNumber(views)),
                    const SizedBox(width: 16),
                    _buildMiniStat(CupertinoIcons.cart, _formatNumber(sales)),
                    const SizedBox(width: 16),
                    _buildMiniStat(
                      CupertinoIcons.money_dollar,
                      '\$${revenue.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
