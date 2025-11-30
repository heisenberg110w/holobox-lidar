import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_item.dart';
import '../widgets/flash_sale_item.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';
import 'recently_viewed_screen.dart';
import 'product_detail_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      child: CupertinoPageScaffold(
        backgroundColor: AppColors.scaffoldBackground,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildCustomAppBar(context),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const SearchBarWidget(),
                    const SizedBox(height: 24),
                    _buildRecentlyViewedButton(context),
                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildCategoriesSection(),
                    const SizedBox(height: 16),
                    _buildFlashSaleSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Holobox Logo Container - Using actual logo image
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/holobox-logo.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          CupertinoIcons.cube_box,
                          color: AppColors.white,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Delivery Address - Center aligned with larger text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery address',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '92 High Street, London',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Notification Icon
              GestureDetector(
                onTap: () {
                  _navigateToNotifications(context);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          CupertinoIcons.bell,
                          color: AppColors.textDark,
                          size: 22,
                        ),
                      ),
                      if (notificationProvider.unreadCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                notificationProvider.unreadCount > 9
                                    ? '9+'
                                    : notificationProvider.unreadCount.toString(),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentlyViewedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          _navigateToRecentlyViewed(context);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple.withValues(alpha: 0.1),
                AppColors.lightBlue.withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryPurple.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.clock,
                  color: AppColors.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Recently Viewed Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.primaryPurple,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: AppColors.textSecondary.withValues(alpha: 0.15),
        thickness: 2,
        height: 2,
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToCategories(context);
                    },
                    child: _buildSeeAllButton(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (homeProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPurple,
                  ),
                ),
              )
            else if (homeProvider.categories.isEmpty)
              _buildEmptyCategories()
            else
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: homeProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = homeProvider.categories[index];
                    final isSelected = category.name == homeProvider.selectedCategory;
                    return CategoryItem(
                      category: category,
                      isSelected: isSelected,
                      onTap: () {
                        homeProvider.setSelectedCategory(category.name);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFlashSaleSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flash Sale Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Flash Sale',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warningOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '02:59:23',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToAllFlashSale(context);
                    },
                    child: _buildSeeAllButton(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Flash Sale Products (controlled by category selection above)
            SizedBox(
              height: 280,
              child: homeProvider.flashSaleProducts.isEmpty
                  ? _buildEmptyFlashSale(homeProvider.selectedCategory)
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homeProvider.flashSaleProducts.length,
                itemBuilder: (context, index) {
                  final product = homeProvider.flashSaleProducts[index];
                  return FlashSaleItem(
                    product: product,
                    onTap: () {
                      _navigateToProductDetail(context, product);
                    },
                  );
                },
              ),
            ),

            // Add padding at bottom to prevent overlap with bottom nav
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  // Enhanced empty state for flash sale
  Widget _buildEmptyFlashSale(String selectedCategory) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.time,
              size: 40,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedCategory == 'All'
                ? 'No flash sale items available'
                : 'No $selectedCategory on flash sale',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedCategory == 'All'
                ? 'Check back later for amazing deals!'
                : 'Try selecting a different category\nfor available flash sale items!',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategories() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              CupertinoIcons.square_grid_2x2,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No categories available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'See all',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            CupertinoIcons.chevron_right,
            color: AppColors.primaryPurple,
            size: 14,
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  void _navigateToRecentlyViewed(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const RecentlyViewedScreen(),
      ),
    );
  }

  void _navigateToCategories(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Navigate to Categories'),
        backgroundColor: AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _navigateToAllFlashSale(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('View all Flash Sale items'),
        backgroundColor: AppColors.warningOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _addProductToCart(BuildContext context, HomeProvider homeProvider, Product product) {
    homeProvider.addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Navigate to Cart'),
                backgroundColor: AppColors.primaryPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
