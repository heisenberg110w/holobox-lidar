import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product_category.dart';

class CategoryItem extends StatelessWidget {
  final ProductCategory category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(category.color)
                    : Color(category.color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Color(category.color)
                      : Color(category.color).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                _getIconData(category.icon),
                color: isSelected
                    ? AppColors.white
                    : Color(category.color),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.textDark : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'cube':
        return CupertinoIcons.cube_box;
      case 'phone':
        return CupertinoIcons.device_phone_portrait;
      case 'gamecontroller':
        return CupertinoIcons.gamecontroller_alt_fill;
      case 'laptop':
        return CupertinoIcons.device_laptop;
      case 'camera':
        return CupertinoIcons.camera;
      case 'headphones':
        return CupertinoIcons.headphones;
      case 'tablet':
        return CupertinoIcons.device_desktop;
      case 'watch':
        return CupertinoIcons.clock; // Fixed: Use CupertinoIcons.clock instead of .watch
      default:
        return CupertinoIcons.cube_box;
    }
  }
}
