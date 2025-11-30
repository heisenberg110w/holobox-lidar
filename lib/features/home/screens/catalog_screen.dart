import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_grid_item.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CatalogProvider(),
      child: const CatalogView(),
    );
  }
}

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Consumer<CatalogProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                _buildHeader(context, provider),
                _buildSearchBar(context, provider),
                _buildCategoryTabs(context, provider),
                // REMOVED: _buildFilterSort section
                Expanded(
                  child: _buildProductGrid(context, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CatalogProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Discover products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          // UPDATED: Added onTap functionality to the filter button
          GestureDetector(
            onTap: () => _showSortBottomSheet(context, provider),
            child: Container(
              width: 40,
              height: 40,
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
              child: const Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 20,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, CatalogProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: provider.setSearchQuery,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, CatalogProvider provider) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 16, bottom: 16), // Added bottom margin for spacing
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final isSelected = category == provider.selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => provider.setCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 36,
                constraints: const BoxConstraints(minWidth: 70),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFA855F7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : LinearGradient(
                    colors: [
                      AppColors.scaffoldBackground,
                      AppColors.scaffoldBackground,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : const Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // REMOVED: _buildFilterSort method completely

  Widget _buildProductGrid(BuildContext context, CatalogProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
      );
    }

    final products = provider.filteredProducts;
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.search,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'Try searching for something else'
                  : 'No products in this category',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshProducts,
      color: AppColors.primaryPurple,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Reduced top padding
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductGridItem(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            onFavorite: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to favorites!'),
                  backgroundColor: AppColors.primaryPurple,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, CatalogProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              ..._buildSortOptions(context, provider),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSortOptions(BuildContext context, CatalogProvider provider) {
    final options = [
      {'value': 'name', 'label': 'Name (A-Z)'},
      {'value': 'price_low', 'label': 'Price (Low to High)'},
      {'value': 'price_high', 'label': 'Price (High to Low)'},
      {'value': 'rating', 'label': 'Rating'},
      {'value': 'popularity', 'label': 'Popularity'},
    ];

    return options.map((option) {
      final isSelected = provider.sortBy == option['value'];
      return ListTile(
        leading: Icon(
          isSelected ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
          color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary,
        ),
        title: Text(
          option['label']!,
          style: TextStyle(
            color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          provider.setSortBy(option['value']!);
          Navigator.pop(context);
        },
      );
    }).toList();
  }
}
