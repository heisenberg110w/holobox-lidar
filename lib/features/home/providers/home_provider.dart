import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/product_category.dart';

class HomeProvider with ChangeNotifier {
  // Private variables
  List<Product> _flashSaleProducts = [];
  List<ProductCategory> _categories = [];
  List<Product> _recentlyViewedProducts = [];
  List<Product> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All'; // Controls flash sale filtering

  // Getters
  List<Product> get flashSaleProducts => _getFilteredFlashSaleProducts();
  List<ProductCategory> get categories => _categories;
  List<Product> get recentlyViewedProducts => _recentlyViewedProducts;
  List<Product> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get cartItemCount => _cartItems.length;
  String get selectedCategory => _selectedCategory;

  // Constructor
  HomeProvider() {
    _initializeData();
  }

  // Set category (controls flash sale filtering)
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get filtered flash sale products based on selected category
  List<Product> _getFilteredFlashSaleProducts() {
    if (_selectedCategory == 'All') {
      return _flashSaleProducts;
    }

    return _flashSaleProducts.where((product) {
      return _getProductCategory(product.name) == _selectedCategory;
    }).toList();
  }

  // Determine product category from name
  String _getProductCategory(String productName) {
    final name = productName.toLowerCase();
    if (name.contains('iphone') || name.contains('phone') || name.contains('samsung galaxy s')) {
      return 'Phones';
    } else if (name.contains('buds') || name.contains('airpods') || name.contains('headphones')) {
      return 'Audio';
    } else if (name.contains('nintendo') || name.contains('console') || name.contains('gaming')) {
      return 'Gaming';
    } else if (name.contains('macbook') || name.contains('laptop')) {
      return 'Laptops';
    } else if (name.contains('ipad') || name.contains('tablet')) {
      return 'Tablets';
    } else if (name.contains('camera') || name.contains('canon')) {
      return 'Cameras';
    } else if (name.contains('watch') || name.contains('apple watch')) {
      return 'Watch';
    }
    return 'Accessories';
  }

  // Initialize all data
  Future<void> _initializeData() async {
    _setLoading(true);
    try {
      await Future.wait([
        _loadCategories(),
        _loadFlashSaleProducts(),
        _loadRecentlyViewedProducts(),
      ]);
      _clearError();
    } catch (e) {
      _setError('Failed to load data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load categories - ALL PURPLE COLORS NOW
  Future<void> _loadCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _categories = [
        const ProductCategory(id: '0', name: 'All', icon: 'cube', color: 0xFF8B5CF6),
        const ProductCategory(id: '1', name: 'Phones', icon: 'phone', color: 0xFF8B5CF6), // Purple
        const ProductCategory(id: '2', name: 'Gaming', icon: 'gamecontroller', color: 0xFF8B5CF6), // Changed from blue to purple
        const ProductCategory(id: '3', name: 'Laptops', icon: 'laptop', color: 0xFF8B5CF6), // Changed from orange to purple
        const ProductCategory(id: '4', name: 'Cameras', icon: 'camera', color: 0xFF8B5CF6), // Changed from green to purple
        const ProductCategory(id: '5', name: 'Audio', icon: 'headphones', color: 0xFF8B5CF6), // Purple
        const ProductCategory(id: '6', name: 'Tablets', icon: 'tablet', color: 0xFF8B5CF6), // Purple
        const ProductCategory(id: '7', name: 'Watch', icon: 'watch', color: 0xFF8B5CF6), // Purple
      ];
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  // Load flash sale products
  Future<void> _loadFlashSaleProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _flashSaleProducts = [
        Product(
          id: '1',
          name: 'Apple iPhone 15 Pro 128GB Natural Titanium',
          description: 'The iPhone 15 Pro features a stunning titanium design with the powerful A17 Pro chip.',
          price: 699.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=iPhone+15+Pro',
          rating: 4.8,
          reviewCount: 117,
          satisfiedPercentage: 94,
          availableStock: 8,
          deliveryDate: '26 October',
        ),
        Product(
          id: '2',
          name: 'Samsung Galaxy Buds Pro True Wireless Black',
          description: 'Premium wireless earbuds with intelligent active noise cancellation.',
          price: 59.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=Galaxy+Buds',
          rating: 4.5,
          reviewCount: 89,
          satisfiedPercentage: 92,
          availableStock: 15,
          deliveryDate: '28 October',
        ),
        Product(
          id: '3',
          name: 'Nintendo Switch Console Gray',
          description: 'The Nintendo Switch gaming console is a compact device that can be taken everywhere.',
          price: 169.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=Nintendo+Switch',
          rating: 4.8,
          reviewCount: 234,
          satisfiedPercentage: 96,
          availableStock: 12,
          deliveryDate: '25 October',
        ),
        Product(
          id: '4',
          name: 'MacBook Pro M3 14-inch Space Gray',
          description: 'Most powerful MacBook Pro ever with M3 chip.',
          price: 1299.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=MacBook+Pro',
          rating: 4.9,
          reviewCount: 156,
          satisfiedPercentage: 97,
          availableStock: 5,
          deliveryDate: '30 October',
        ),
        Product(
          id: '5',
          name: 'Apple Watch Series 9 GPS 41mm',
          description: 'Most advanced Apple Watch with double tap gesture.',
          price: 329.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=Apple+Watch',
          rating: 4.6,
          reviewCount: 203,
          satisfiedPercentage: 93,
          availableStock: 20,
          deliveryDate: '27 October',
        ),
        Product(
          id: '6',
          name: 'iPad Pro 11-inch M2 256GB',
          description: 'Most advanced iPad Pro ever with M2 chip.',
          price: 799.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=iPad+Pro',
          rating: 4.7,
          reviewCount: 89,
          satisfiedPercentage: 95,
          availableStock: 12,
          deliveryDate: '29 October',
        ),
      ];
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load flash sale products');
    }
  }

  // Load recently viewed products
  Future<void> _loadRecentlyViewedProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _recentlyViewedProducts = [
        Product(
          id: 'rv1',
          name: 'iPad Pro 11-inch M2',
          description: 'Most advanced iPad Pro ever with M2 chip',
          price: 799.00,
          imageUrl: 'https://via.placeholder.com/300x300.png?text=iPad+Pro',
          rating: 4.6,
          reviewCount: 45,
          satisfiedPercentage: 91,
          availableStock: 10,
          deliveryDate: '29 October',
        ),
      ];
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load recently viewed products');
    }
  }

  // Add product to cart
  void addToCart(Product product) {
    try {
      final existingIndex = _cartItems.indexWhere((item) => item.id == product.id);
      if (existingIndex >= 0) {
        debugPrint('Product ${product.name} already in cart');
      } else {
        _cartItems.add(product);
        debugPrint('Added ${product.name} to cart');
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to add product to cart');
    }
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    try {
      _cartItems.removeWhere((item) => item.id == productId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to remove product from cart');
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Get cart total
  double get cartTotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.id == productId);
  }

  // Refresh all data
  Future<void> refreshData() async {
    await _initializeData();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
    debugPrint('HomeProvider Error: $error');
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
