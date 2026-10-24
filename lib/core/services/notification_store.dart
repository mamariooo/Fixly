import 'package:flutter/foundation.dart';

enum NotificationAudience { customer, technician }

class AppNotification {
  AppNotification({
    required this.title,
    required this.body,
    required this.audience,
    required this.createdAt,
    this.read = false,
  });

  final String title;
  final String body;
  final NotificationAudience audience;
  final DateTime createdAt;
  bool read;
}

/// إشعارات داخل التطبيق (في الذاكرة).
/// لما نربط Firebase هنضيف FCM للإشعارات الحقيقية.
class NotificationStore extends ChangeNotifier {
  NotificationStore._();
  static final NotificationStore instance = NotificationStore._();

  final List<AppNotification> _items = [];

  /// إعداد من صفحة Settings: لو اتقفل، العميل مش بيستقبل إشعارات جديدة
  bool customerEnabled = true;

  void setCustomerEnabled(bool value) {
    customerEnabled = value;
    notifyListeners();
  }

  List<AppNotification> forAudience(NotificationAudience a) =>
      _items.where((n) => n.audience == a).toList().reversed.toList();

  int unreadCount(NotificationAudience a) =>
      _items.where((n) => n.audience == a && !n.read).length;

  void add({
    required NotificationAudience audience,
    required String title,
    required String body,
  }) {
    if (audience == NotificationAudience.customer && !customerEnabled) return;
    _items.add(AppNotification(
      title: title,
      body: body,
      audience: audience,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void markAllRead(NotificationAudience a) {
    for (final n in _items) {
      if (n.audience == a) n.read = true;
    }
    notifyListeners();
  }
}