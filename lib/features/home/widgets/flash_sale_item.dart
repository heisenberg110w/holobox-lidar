import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class FlashSaleItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const FlashSaleItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, CartProvider>(
      builder: (context, favoritesProvider, cartProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(product.id);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context, favoritesProvider, isFavorite),
                _buildProductInfo(context, cartProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, FavoritesProvider favoritesProvider, bool isFavorite) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: _getProductGradient(),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getProductIcon(),
                      size: 40,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getProductCategory(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white.withValues(alpha: 0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                favoritesProvider.toggleFavorite(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite ? 'Removed from favorites' : 'Added to favorites',
                    ),
                    backgroundColor: isFavorite ? AppColors.error : AppColors.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
                  size: 14,
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.warningOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-${_getDiscountPercentage()}%',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, CartProvider cartProvider) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '£${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (product.originalPrice > product.price)
                        Text(
                          '£${product.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    cartProvider.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart!'),
                        backgroundColor: AppColors.primaryPurple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.plus,
                      color: AppColors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getProductGradient() {
    if (product.name.toLowerCase().contains('iphone') ||
        product.name.toLowerCase().contains('apple')) {
      return const LinearGradient(
        colors: [Color(0xFF1D1D1F), Color(0xFF2D2D30), Color(0xFF48484A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (product.name.toLowerCase().contains('samsung') ||
        product.name.toLowerCase().contains('galaxy')) {
      return const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF1E88E5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (product.name.toLowerCase().contains('nintendo')) {
      return const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFD32F2F), Color(0xFFB71C1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFAB7DF8), Color(0xFFCB9DFA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  IconData _getProductIcon() {
    if (product.name.toLowerCase().contains('iphone') ||
        product.name.toLowerCase().contains('phone')) {
      return CupertinoIcons.device_phone_portrait;
    } else if (product.name.toLowerCase().contains('buds') ||
        product.name.toLowerCase().contains('airpods') ||
        product.name.toLowerCase().contains('headphones')) {
      return CupertinoIcons.headphones;
    } else if (product.name.toLowerCase().contains('nintendo') ||
        product.name.toLowerCase().contains('console')) {
      return CupertinoIcons.gamecontroller_alt_fill;
    }
    return CupertinoIcons.cube_box;
  }

  String _getProductCategory() {
    if (product.name.toLowerCase().contains('iphone') ||
        product.name.toLowerCase().contains('phone')) {
      return 'SMARTPHONE';
    } else if (product.name.toLowerCase().contains('buds') ||
        product.name.toLowerCase().contains('airpods') ||
        product.name.toLowerCase().contains('headphones')) {
      return 'AUDIO';
    } else if (product.name.toLowerCase().contains('nintendo') ||
        product.name.toLowerCase().contains('console')) {
      return 'GAMING';
    }
    return 'PRODUCT';
  }

  int _getDiscountPercentage() {
    if (product.originalPrice > 0 && product.originalPrice > product.price) {
      return ((product.originalPrice - product.price) / product.originalPrice * 100).round();
    }
    return 20;
  }
}
