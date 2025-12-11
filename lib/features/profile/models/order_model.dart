class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String color;
  final String size;
  final String? imageUrl;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.color,
    required this.size,
    this.imageUrl,
  });
}

class Order {
  final String orderId;
  final List<OrderItem> items;
  final String status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String deliveryAddress;
  final double total;

  Order({
    required this.orderId,
    required this.items,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.deliveryAddress,
    required this.total,
  });

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'on the way':
        return 'orange';
      case 'shipped to customer':
        return 'green';
      case 'delivered':
        return 'blue';
      case 'cancelled':
        return 'red';
      default:
        return 'gray';
    }
  }
}
