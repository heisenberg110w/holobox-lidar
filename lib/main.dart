import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'features/home/providers/home_provider.dart';
import 'features/home/providers/notification_provider.dart';
import 'features/home/providers/catalog_provider.dart';
import 'features/home/providers/favorites_provider.dart';
import 'features/home/providers/cart_provider.dart'; // ADD THIS LINE
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/catalog_screen.dart';
import 'features/home/screens/favorites_screen.dart';
import 'features/home/screens/product_detail_screen.dart';
import 'features/home/widgets/product_grid_item.dart';
import 'features/home/models/product_model.dart'; // ADD THIS LINE TOO
import 'core/theme/app_colors.dart';
import 'features/home/providers/recently_viewed_provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),// ADD THIS LINE
      ],
      child: MaterialApp(
        title: 'Ecommerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CatalogScreen(),
    const CartScreen(),
    const FavoritesScreenWithProvider(), // CHANGED THIS LINE
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBackground,
        ),
        child: SafeArea(
          child: Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(0, CupertinoIcons.house, CupertinoIcons.house_fill, 'Home'),
                _buildNavItem(1, CupertinoIcons.square_grid_2x2, CupertinoIcons.square_grid_2x2_fill, 'Catalog'),
                _buildCartButton(),
                _buildNavItem(3, CupertinoIcons.heart, CupertinoIcons.heart_fill, 'Favorites'),
                _buildNavItem(4, CupertinoIcons.person, CupertinoIcons.person_fill, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: SizedBox(
        width: 55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    bool isActive = _currentIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Transform.translate(
        offset: const Offset(0, -6),
        child: Container(
          width: 60,
          height: 70,
          alignment: Alignment.center,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryPurple,
                  AppColors.lightBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isActive ? CupertinoIcons.cart_fill : CupertinoIcons.shopping_cart,
                color: AppColors.white,
                size: 28,
              ),
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
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, cartProvider),
                Expanded(
                  child: cartProvider.itemCount == 0
                      ? _buildEmptyCart(context)
                      : _buildCartItems(context, cartProvider),
                ),
                if (cartProvider.itemCount > 0)
                  _buildCheckoutSection(context, cartProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cartProvider.itemCount == 0
                      ? 'No items'
                      : '${cartProvider.totalQuantity} ${cartProvider.totalQuantity == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (cartProvider.itemCount > 0)
            GestureDetector(
              onTap: () => _showClearDialog(context, cartProvider),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      CupertinoIcons.trash,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                  color: AppColors.black.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              child: Icon(
                CupertinoIcons.cart,
                size: 44,
                color: AppColors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add products to get started',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, CartProvider cartProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartProvider.items.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.items.values.toList()[index];
        return _buildCartItem(context, cartItem, cartProvider);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem, CartProvider cartProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFAB7DF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.cube_box,
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '£${cartItem.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.black.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => cartProvider.decreaseQuantity(cartItem.product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          CupertinoIcons.minus,
                          size: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cartProvider.increaseQuantity(cartItem.product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          CupertinoIcons.plus,
                          size: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => cartProvider.removeItem(cartItem.product.id),
                child: Icon(
                  CupertinoIcons.trash,
                  size: 18,
                  color: AppColors.error.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '£${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Delivery',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'FREE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: AppColors.black.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '£${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 52,
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
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Checkout logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proceeding to checkout...'),
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: const Center(
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, CartProvider cartProvider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This will remove all items from your cart.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}


class FavoritesScreenWithProvider extends StatelessWidget {
  const FavoritesScreenWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favorites = favoritesProvider.favoriteProducts;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [
                _buildCleanHeader(context, favoritesProvider),
                Expanded(
                  child: favorites.isEmpty
                      ? _buildMinimalEmptyState(context)
                      : _buildFavoritesList(context, favorites, favoritesProvider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanHeader(BuildContext context, FavoritesProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.favoriteCount == 0
                      ? 'No items saved'
                      : '${provider.favoriteCount} ${provider.favoriteCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (provider.favoriteCount > 0)
            GestureDetector(
              onTap: () => _showClearDialog(context, provider),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      CupertinoIcons.trash,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }



  Widget _buildMinimalEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                  color: AppColors.black.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              child: Icon(
                CupertinoIcons.heart,
                size: 44,
                color: AppColors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart icon on products\nto save them here',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List favorites, FavoritesProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        return ProductGridItem(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }

  void _showClearDialog(BuildContext context, FavoritesProvider provider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Clear all favorites?'),
        content: const Text('This will remove all items from your favorites.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              provider.clearFavorites();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      size: 20,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryPurple,
                            AppColors.lightBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.person_fill,
                        size: 50,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildProfileOption(
                      icon: CupertinoIcons.person,
                      title: 'Account Settings',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.location,
                      title: 'Addresses',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.creditcard,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.doc_text,
                      title: 'Order History',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.bell,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.question_circle,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: CupertinoIcons.settings,
                      title: 'Settings',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
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
        ),
      ),
    );
  }
}
