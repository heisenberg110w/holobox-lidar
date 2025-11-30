import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product_model.dart';
import '../providers/favorites_provider.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(product.id);

        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.65,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: _buildProductImage(),
                            ),
                          ),
                          if (product.discountPercentage > 0)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF416C),
                                      Color(0xFFFF4B2B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF416C).withValues(alpha: 0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '-${product.discountPercentage}%',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
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
                                if (onFavorite != null) {
                                  onFavorite!();
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.95),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                  size: 16,
                                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      size: 10,
                                      color: Color(0xFFFFA726),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (product.availableStock < 10)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      '${product.availableStock} left',
                                      style: const TextStyle(
                                        fontSize: 7,
                                        color: Color(0xFFFF9800),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '£${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                                if (product.originalPrice > product.price)
                                  Text(
                                    '£${product.originalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.deliveryDate,
                              style: const TextStyle(
                                fontSize: 8,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductImage() {
    final gradientColors = _getProductGradient();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.5,
                  colors: [
                    AppColors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getProductIcon(),
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getProductCategory(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getProductGradient() {
    final productName = product.name.toLowerCase();

    if (productName.contains('iphone') || productName.contains('apple')) {
      return [
        const Color(0xFF1A1A1A),
        const Color(0xFF2D2D30),
        const Color(0xFF424245),
      ];
    } else if (productName.contains('samsung') || productName.contains('galaxy')) {
      return [
        const Color(0xFF1E3C72),
        const Color(0xFF2A5298),
        const Color(0xFF3B82F6),
      ];
    } else if (productName.contains('nintendo') || productName.contains('switch')) {
      return [
        const Color(0xFFDC1C13),
        const Color(0xFFE53E3E),
        const Color(0xFFFF6B6B),
      ];
    } else if (productName.contains('macbook') || productName.contains('laptop')) {
      return [
        const Color(0xFF4A5568),
        const Color(0xFF718096),
        const Color(0xFF9CA3AF),
      ];
    } else if (productName.contains('camera') || productName.contains('canon')) {
      return [
        const Color(0xFF1A202C),
        const Color(0xFF2D3748),
        const Color(0xFF4A5568),
      ];
    } else if (productName.contains('watch')) {
      return [
        const Color(0xFF3182CE),
        const Color(0xFF4299E1),
        const Color(0xFF63B3ED),
      ];
    } else if (productName.contains('headphones') ||
        productName.contains('buds') ||
        productName.contains('wh-') ||
        productName.contains('sony') ||
        productName.contains('audio')) {
      return [
        const Color(0xFF553C9A),
        const Color(0xFF7C3AED),
        const Color(0xFF8B5CF6),
      ];
    } else {
      return [
        const Color(0xFF6B46C1),
        const Color(0xFF8B5CF6),
        const Color(0xFFA78BFA),
      ];
    }
  }

  IconData _getProductIcon() {
    final productName = product.name.toLowerCase();

    if (productName.contains('headphones') ||
        productName.contains('buds') ||
        productName.contains('earphones') ||
        productName.contains('earbuds') ||
        productName.contains('wh-') ||
        productName.contains('airpods') ||
        productName.contains('beats') ||
        productName.contains('audio') ||
        productName.contains('speaker') ||
        productName.contains('sound')) {
      return CupertinoIcons.headphones;
    }
    else if (productName.contains('iphone') || productName.contains('phone')) {
      return CupertinoIcons.device_phone_portrait;
    }
    else if (productName.contains('watch')) {
      return CupertinoIcons.time;
    }
    else if (productName.contains('macbook') || productName.contains('laptop')) {
      return CupertinoIcons.desktopcomputer;
    }
    else if (productName.contains('ipad') || productName.contains('tablet')) {
      return CupertinoIcons.rectangle;
    }
    else if (productName.contains('camera')) {
      return CupertinoIcons.camera;
    }
    else if (productName.contains('nintendo') || productName.contains('switch') || productName.contains('console')) {
      return CupertinoIcons.gamecontroller;
    }
    else {
      return CupertinoIcons.cube_box;
    }
  }

  String _getProductCategory() {
    final productName = product.name.toLowerCase();

    if (productName.contains('headphones') ||
        productName.contains('buds') ||
        productName.contains('earphones') ||
        productName.contains('earbuds') ||
        productName.contains('wh-') ||
        productName.contains('airpods') ||
        productName.contains('beats') ||
        productName.contains('audio') ||
        productName.contains('speaker') ||
        productName.contains('sound')) {
      return 'AUDIO';
    }
    else if (productName.contains('iphone') || productName.contains('phone')) {
      return 'SMARTPHONE';
    }
    else if (productName.contains('watch')) {
      return 'SMART WATCH';
    }
    else if (productName.contains('macbook') || productName.contains('laptop')) {
      return 'LAPTOP';
    }
    else if (productName.contains('ipad') || productName.contains('tablet')) {
      return 'TABLET';
    }
    else if (productName.contains('camera')) {
      return 'CAMERA';
    }
    else if (productName.contains('nintendo') || productName.contains('switch') || productName.contains('console')) {
      return 'GAMING';
    }
    else {
      return 'ELECTRONICS';
    }
  }
}
