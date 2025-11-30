class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int satisfiedPercentage;
  final int availableStock;
  final String deliveryDate;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.satisfiedPercentage,
    required this.availableStock,
    required this.deliveryDate,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? satisfiedPercentage,
    int? availableStock,
    String? deliveryDate,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      satisfiedPercentage: satisfiedPercentage ?? this.satisfiedPercentage,
      availableStock: availableStock ?? this.availableStock,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }

  // Helper getters for compatibility
  double get originalPrice => price * 1.2; // Assuming 20% discount
  int get discountPercentage => 20;
  String get category => 'Electronics'; // Default category
  bool get isFlashSale => true; // Default flash sale
}
