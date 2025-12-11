import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // DEMO DATA - Replace with database data later
  final List<Order> _demoOrders = [
    Order(
      orderId: '73262',
      items: [
        OrderItem(
          name: 'Wireless Bluetooth Headphones',
          quantity: 1,
          price: 340,
          color: 'Black',
          size: 'Standard',
        ),
        OrderItem(
          name: 'Smart Watch Series 5',
          quantity: 1,
          price: 450,
          color: 'Silver',
          size: '42mm',
        ),
        OrderItem(
          name: 'USB-C Charging Cable',
          quantity: 2,
          price: 25,
          color: 'White',
          size: '2m',
        ),
      ],
      status: 'On the way',
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
      deliveryAddress: '123 Main Street, New York, NY 10001',
      total: 840.00,
    ),
    Order(
      orderId: '09177',
      items: [
        OrderItem(
          name: 'Leather Wallet',
          quantity: 1,
          price: 89,
          color: 'Brown',
          size: 'Standard',
        ),
        OrderItem(
          name: 'Sunglasses Premium',
          quantity: 1,
          price: 199,
          color: 'Black',
          size: 'Medium',
        ),
      ],
      status: 'Shipped to customer',
      orderDate: DateTime.now().subtract(const Duration(days: 7)),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      deliveryAddress: '123 Main Street, New York, NY 10001',
      total: 288.00,
    ),
    Order(
      orderId: '45892',
      items: [
        OrderItem(
          name: 'Running Shoes Pro',
          quantity: 1,
          price: 120,
          color: 'Blue',
          size: 'UK 9',
        ),
      ],
      status: 'Delivered',
      orderDate: DateTime.now().subtract(const Duration(days: 15)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 10)),
      deliveryAddress: '123 Main Street, New York, NY 10001',
      total: 120.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryPurple,
          labelColor: AppColors.primaryPurple,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'Unpaid'),
            Tab(text: 'All orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_demoOrders.where((o) => o.status != 'Delivered').toList()),
          _buildEmptyState('No unpaid orders'),
          _buildOrdersList(_demoOrders),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState('No orders found');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #: ${order.orderId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.items.length} Products | ${_formatDate(order.orderDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download invoice')),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.black.withOpacity(0.06)),
          // Order Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Status:', order.status,
                    statusColor: _getStatusColor(order.status)),
                const SizedBox(height: 8),
                if (order.deliveryDate != null)
                  _buildDetailRow('Date of delivery:',
                      _formatDate(order.deliveryDate!)),
                const SizedBox(height: 8),
                _buildDetailRow('Delivered to:', order.deliveryAddress),
                const SizedBox(height: 8),
                _buildDetailRow(
                    'Total:', '\$${order.total.toStringAsFixed(2)}',
                    isBold: true),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.black.withOpacity(0.06)),
          // Order Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.items.map((item) {
                return _buildOrderItem(item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? statusColor, bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: statusColor ?? AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
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
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
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
                  'Quantity: ${item.quantity}x = \$${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Color: ${item.color}  •  Size: ${item.size}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.cube_box,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on the way':
        return Colors.orange;
      case 'shipped to customer':
        return Colors.green;
      case 'delivered':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
