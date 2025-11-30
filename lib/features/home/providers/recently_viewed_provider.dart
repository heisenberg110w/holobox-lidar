import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class RecentlyViewedProvider with ChangeNotifier {
  final List<Product> _recentlyViewedProducts = [];
  final int _maxItems = 20;

  List<Product> get recentlyViewedProducts => List.unmodifiable(_recentlyViewedProducts);

  int get count => _recentlyViewedProducts.length;

  void addProduct(Product product) {
    _recentlyViewedProducts.removeWhere((p) => p.id == product.id);

    _recentlyViewedProducts.insert(0, product);

    if (_recentlyViewedProducts.length > _maxItems) {
      _recentlyViewedProducts.removeLast();
    }

    notifyListeners();
  }

  void clearHistory() {
    _recentlyViewedProducts.clear();
    notifyListeners();
  }
}
