import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home/screens/home_screen.dart';
import '../../core/theme/app_colors.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.cardBackground.withValues(alpha: 0.95),
        border: const Border(),
        activeColor: AppColors.primaryPurple,
        inactiveColor: AppColors.darkGray,
        iconSize: 24,
        height: 60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            activeIcon: Icon(CupertinoIcons.cart_fill),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const CatalogScreen();
              case 2:
                return const CartScreen();
              case 3:
                return const FavoritesScreen();
              case 4:
                return const ProfileScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}

// Placeholder screens
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.scaffoldBackground,
        middle: Text(
          'Catalog',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: AppColors.textDark,
          ),
        ),
        border: Border(),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Catalog Screen',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.scaffoldBackground,
        middle: Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: AppColors.textDark,
          ),
        ),
        border: Border(),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Cart Screen',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.scaffoldBackground,
        middle: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: AppColors.textDark,
          ),
        ),
        border: Border(),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Favorites Screen',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.scaffoldBackground,
        middle: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: AppColors.textDark,
          ),
        ),
        border: Border(),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Profile Screen',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
