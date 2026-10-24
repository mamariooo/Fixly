import 'package:flutter/foundation.dart';
import 'package:fixly/core/models/booking.dart';
import 'package:fixly/core/services/notification_store.dart';

/// مخزن حجوزات في الذاكرة (بدل الـ backend).
/// الشاشات بتسمع له وبتتحدث لوحدها لما يتغير أي حاجة.
/// لما نربط Firebase هنبدّل جواه بس من غير ما نلمس الشاشات.
class BookingStore extends ChangeNotifier {
  BookingStore._();
  static final BookingStore instance = BookingStore._();

  final List<Booking> _items = [];
  final Set<String> _declined = {};
  int _counter = 0;

  // ---------- للعميل ----------
  List<Booking> get active =>
      _items.where((b) => b.status.isActive).toList().reversed.toList();

  List<Booking> get past =>
      _items.where((b) => !b.status.isActive).toList().reversed.toList();

Booking create({
    required String service,
    required String issue,
    required String urgency,
    String? address,
    String? paymentMethod,
  }) {
    final b = Booking(
      id: 'B${++_counter}',
      service: service,
      issue: issue,
      urgency: urgency,
      address: address,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );
    _items.add(b);
    NotificationStore.instance.add(
      audience: NotificationAudience.technician,
      title: 'طلب جديد',
      body: '${b.issue} (${b.service})',
    );
    notifyListeners();
    return b;
  }

void cancel(Booking b) {
    if (!b.status.isActive) return;
    if (b.status == BookingStatus.inProgress) return;
    final wasAccepted = b.status == BookingStatus.accepted;
    b.status = BookingStatus.cancelled;
    if (wasAccepted) {
      NotificationStore.instance.add(
        audience: NotificationAudience.technician,
        title: 'تم إلغاء طلب',
        body: b.issue,
      );
    }
    notifyListeners();
  }

  void rate(Booking b, int stars) {
    if (b.status != BookingStatus.completed) return;
    b.rating = stars;
    notifyListeners();
  }

  // ---------- للفني ----------
  /// طلبات جديدة لسه محدش قبلها (ومش اللي الفني رفضها)
  List<Booking> get pendingRequests => _items
      .where((b) =>
          b.status == BookingStatus.pending && !_declined.contains(b.id))
      .toList();

  /// الشغل اللي الفني قبله ولسه مخلصش
  List<Booking> get technicianJobs => _items
      .where((b) =>
          b.status == BookingStatus.accepted ||
          b.status == BookingStatus.onTheWay ||
          b.status == BookingStatus.inProgress)
      .toList();

  List<Booking> get completedJobs =>
      _items.where((b) => b.status == BookingStatus.completed).toList();

  void accept(Booking b, {String technicianName = 'Hossam Ali'}) {
    if (b.status != BookingStatus.pending) return;
    b.status = BookingStatus.accepted;
    b.technicianName = technicianName;
    NotificationStore.instance.add(
      audience: NotificationAudience.customer,
      title: 'Request accepted',
      body: '$technicianName accepted your request: ${b.issue}',
    );
    notifyListeners();
  }
  void decline(Booking b) {
    _declined.add(b.id);
    notifyListeners();
  }

/// accepted -> onTheWay -> inProgress -> completed
  void advance(Booking b, {int? price}) {
    String title;
    String body;
    switch (b.status) {
      case BookingStatus.accepted:
        b.status = BookingStatus.onTheWay;
        title = 'Technician on the way';
        body = '${b.technicianName ?? 'Your technician'} is heading to you.';
        break;
      case BookingStatus.onTheWay:
        b.status = BookingStatus.inProgress;
        title = 'Work started';
        body = 'Your technician started working on: ${b.issue}';
        break;
      case BookingStatus.inProgress:
        b.status = BookingStatus.completed;
        if (price != null) b.price = price;
        title = 'Job completed';
        body = 'Please rate your technician.';
        break;
      default:
        return;
    }
    NotificationStore.instance.add(
      audience: NotificationAudience.customer,
      title: title,
      body: body,
    );
    notifyListeners();
  }
}