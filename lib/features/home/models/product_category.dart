class ProductCategory {
  final String id;
  final String name;
  final String icon;
  final int color;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  ProductCategory copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
