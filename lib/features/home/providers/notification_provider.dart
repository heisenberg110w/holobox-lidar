import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;
  bool get isLoading => _isLoading;

  NotificationProvider() {
    _loadSampleNotifications();
  }

  void _loadSampleNotifications() {
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Order Shipped! 📦',
        message: 'Your iPhone 15 Pro has been shipped and will arrive by tomorrow.',
        type: 'order',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        imageUrl: 'https://via.placeholder.com/60x60.png?text=📦',
      ),
      NotificationModel(
        id: '2',
        title: 'Flash Sale Alert! ⚡',
        message: 'Samsung Galaxy Buds Pro now 34% off. Limited time offer!',
        type: 'promo',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: 'https://via.placeholder.com/60x60.png?text=⚡',
      ),
      NotificationModel(
        id: '3',
        title: 'Payment Successful 💳',
        message: 'Your payment of £699.00 for iPhone 15 Pro has been processed.',
        type: 'order',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        imageUrl: 'https://via.placeholder.com/60x60.png?text=💳',
      ),
    ];
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  Future<void> refreshNotifications() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}
