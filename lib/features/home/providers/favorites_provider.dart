import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;
  int get favoriteCount => _favoriteProducts.length;

  bool isFavorite(String productId) {
    return _favoriteProducts.any((product) => product.id == productId);
  }

  void toggleFavorite(Product product) {
    final index = _favoriteProducts.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _favoriteProducts.removeAt(index);
      debugPrint('Removed ${product.name} from favorites');
    } else {
      _favoriteProducts.add(product);
      debugPrint('Added ${product.name} to favorites');
    }

    notifyListeners();
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favoriteProducts.add(product);
      debugPrint('Added ${product.name} to favorites');
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favoriteProducts.removeWhere((product) => product.id == productId);
    debugPrint('Removed product from favorites');
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProducts.clear();
    notifyListeners();
  }
}
