import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CatalogProvider with ChangeNotifier {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _isLoading = false;
  String? _errorMessage;

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final List<String> _categories = [
    'All',
    'Phones',
    'Consoles',
    'Laptops',
    'Cameras',
    'Audio',
    'Accessories',
    'Tablets'
  ];

  List<String> get categories => _categories;

  final List<Product> _allProducts = [
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
      name: 'Sony WH-1000XM5 Wireless Headphones',
      description: 'Industry-leading noise cancellation with premium sound quality.',
      price: 199.00,
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Sony+Headphones',
      rating: 4.7,
      reviewCount: 234,
      satisfiedPercentage: 96,
      availableStock: 12,
      deliveryDate: '27 October',
    ),
    Product(
      id: '4',
      name: 'Nintendo Switch OLED White',
      description: 'Enhanced gaming experience with vibrant OLED screen.',
      price: 169.00,
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Switch+OLED',
      rating: 4.8,
      reviewCount: 445,
      satisfiedPercentage: 97,
      availableStock: 20,
      deliveryDate: '25 October',
    ),
    Product(
      id: '5',
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
      id: '6',
      name: 'Canon EOS R6 Mark II Camera',
      description: 'Professional mirrorless camera with exceptional image quality.',
      price: 1899.00,
      imageUrl: 'https://via.placeholder.com/300x300.png?text=Canon+R6',
      rating: 4.8,
      reviewCount: 67,
      satisfiedPercentage: 95,
      availableStock: 8,
      deliveryDate: '2 November',
    ),
    Product(
      id: '7',
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
    Product(
      id: '8',
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
  ];

  List<Product> get filteredProducts {
    List<Product> products = _allProducts;

    // Filter by category - FIXED LOGIC
    if (_selectedCategory != 'All') {
      products = products.where((product) {
        return _matchesCategory(product, _selectedCategory);
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort products
    switch (_sortBy) {
      case 'price_low':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popularity':
        products.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'name':
      default:
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return products;
  }

  // FIXED: More specific category matching logic
  bool _matchesCategory(Product product, String category) {
    final name = product.name.toLowerCase();
    final description = product.description.toLowerCase();

    switch (category) {
      case 'Phones':
      // Only match if it's actually a phone, not just contains "Samsung"
        return (name.contains('iphone') ||
            name.contains('phone') ||
            (name.contains('samsung') && name.contains('galaxy s')) ||
            (name.contains('samsung') && name.contains('galaxy z')) ||
            (name.contains('samsung') && name.contains('galaxy note')) ||
            name.contains('pixel') ||
            name.contains('oneplus')) &&
            !name.contains('buds') &&
            !name.contains('headphones') &&
            !name.contains('earbuds');

      case 'Audio':
      // Specific audio device keywords
        return name.contains('buds') ||
            name.contains('headphones') ||
            name.contains('earbuds') ||
            name.contains('airpods') ||
            name.contains('speaker') ||
            name.contains('audio') ||
            description.contains('wireless earbuds') ||
            description.contains('headphones');

      case 'Consoles':
        return name.contains('nintendo') ||
            name.contains('switch') ||
            name.contains('playstation') ||
            name.contains('ps5') ||
            name.contains('ps4') ||
            name.contains('xbox') ||
            description.contains('gaming console');

      case 'Laptops':
        return name.contains('macbook') ||
            name.contains('laptop') ||
            name.contains('thinkpad') ||
            name.contains('surface') ||
            description.contains('laptop');

      case 'Cameras':
        return name.contains('camera') ||
            name.contains('canon') ||
            name.contains('nikon') ||
            name.contains('sony alpha') ||
            name.contains('eos') ||
            description.contains('mirrorless') ||
            description.contains('dslr');

      case 'Tablets':
        return name.contains('ipad') ||
            name.contains('tablet') ||
            name.contains('galaxy tab') ||
            description.contains('tablet');

      case 'Accessories':
        return !_matchesCategory(product, 'Phones') &&
            !_matchesCategory(product, 'Audio') &&
            !_matchesCategory(product, 'Consoles') &&
            !_matchesCategory(product, 'Laptops') &&
            !_matchesCategory(product, 'Cameras') &&
            !_matchesCategory(product, 'Tablets');

      default:
        return true;
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
