import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../database/firestore_paths.dart';
import '../models/booking.dart';
import 'notification_store.dart';

class BookingStore extends ChangeNotifier {
  BookingStore._() {
    startListening();
    // أعد الاشتراك عند تغيّر المستخدم (تسجيل دخول / خروج)
    _authSub = _auth.authStateChanges().listen((_) => startListening());
  }

  static final BookingStore instance = BookingStore._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Booking> _items = [];
  final Set<String> _declined = {};
  StreamSubscription? _clientSub;
  StreamSubscription? _techSub;
  StreamSubscription? _authSub;
  final Map<String, Booking> _asClient = {};
  final Map<String, Booking> _asTech = {};

  CollectionReference get _collection =>
      _db.collection(FirestorePaths.serviceRequests);

  /// نسمع فقط على طلبات المستخدم الحالي (كعميل أو كفني) بدل كل الـ collection.
  void startListening() {
    _clientSub?.cancel();
    _techSub?.cancel();
    _asClient.clear();
    _asTech.clear();
    _items = [];
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    _clientSub = _listenTo('clientId', uid, _asClient);
    _techSub = _listenTo('technicianId', uid, _asTech);
  }

  StreamSubscription _listenTo(
    String field,
    String uid,
    Map<String, Booking> target,
  ) {
    return _collection.where(field, isEqualTo: uid).snapshots().listen(
      (snap) {
        target
          ..clear()
          ..addEntries(
            snap.docs.map(
              (d) => MapEntry(
                d.id,
                Booking.fromMap(d.data() as Map<String, dynamic>, d.id),
              ),
            ),
          );
        _rebuild();
      },
      onError: (e) => debugPrint('BookingStore listen error ($field): $e'),
    );
  }

  void _rebuild() {
    final merged = <String, Booking>{..._asTech, ..._asClient};
    _items = merged.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // ---------- للعميل ----------
  List<Booking> get active {
    final uid = _auth.currentUser?.uid;
    return _items
        .where(
          (b) =>
              b.status.isActive &&
              (uid == null || b.clientId == null || b.clientId == uid),
        )
        .toList();
  }

  List<Booking> get past {
    final uid = _auth.currentUser?.uid;
    return _items
        .where(
          (b) =>
              !b.status.isActive &&
              (uid == null || b.clientId == null || b.clientId == uid),
        )
        .toList();
  }

  /// إنشاء طلب جديد مع بيانات الذكاء الاصطناعي والصور والفني المختار
  Future<Booking> create({
    required String service,
    required String issue,
    required String urgency,
    String? address,
    String? paymentMethod,
    String? clientName,
    String? clientPhone,
    String? technicianId,
    String? technicianName,
    String? technicianPhone,
    String? aiSummary,
    bool needsExpert = false,
    List<String> photoUrls = const [],
  }) async {
    final user = _auth.currentUser;
    final now = DateTime.now();

    final docRef = _collection.doc();
    final booking = Booking(
      id: docRef.id,
      service: service,
      issue: issue,
      urgency: urgency,
      createdAt: now,
      clientId: user?.uid,
      clientName: clientName ?? user?.displayName ?? 'عميل Fixly',
      clientPhone: clientPhone ?? user?.phoneNumber,
      technicianId: technicianId,
      technicianName: technicianName,
      technicianPhone: technicianPhone,
      address: address,
      paymentMethod: paymentMethod,
      aiSummary: aiSummary,
      needsExpert: needsExpert,
      photoUrls: photoUrls,
      status: BookingStatus.pending,
    );

    // إضافة محلية فورية
    _items.insert(0, booking);
    notifyListeners();

    try {
      final data = booking.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      await docRef.set(data);
    } catch (e) {
      // لا نخفي الفشل: الطلب لم يصل للفني فيجب أن يعرف العميل.
      debugPrint('Failed to save booking to Firestore: $e');
      _items.remove(booking);
      notifyListeners();
      rethrow;
    }

    NotificationStore.instance.add(
      audience: NotificationAudience.technician,
      title: 'طلب صيانة جديد',
      body: '${booking.issue} (${booking.service})',
    );
    return booking;
  }

  Future<void> cancel(Booking b) async {
    if (!b.status.isActive) return;
    if (b.status == BookingStatus.inProgress) return;
    final wasAccepted = b.status == BookingStatus.accepted;

    b.status = BookingStatus.cancelled;
    notifyListeners();

    try {
      await _collection.doc(b.id).update({
        'status': BookingStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
    }

    if (wasAccepted) {
      NotificationStore.instance.add(
        audience: NotificationAudience.technician,
        title: 'تم إلغاء الطلب',
        body: b.issue,
      );
    }
  }

  Future<void> rate(Booking b, int stars) async {
    if (b.status != BookingStatus.completed) return;
    b.rating = stars;
    notifyListeners();

    try {
      await _collection.doc(b.id).update({
        'rating': stars,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error rating booking: $e');
    }
  }

  // ---------- للفني ----------
  List<Booking> get pendingRequests => _items
      .where(
        (b) =>
            b.status == BookingStatus.pending &&
            !_declined.contains(b.id) &&
            b.technicianId != null &&
            b.technicianId == _auth.currentUser?.uid,
      )
      .toList();

  List<Booking> get technicianJobs => _items
      .where(
        (b) =>
            b.technicianId != null &&
            b.technicianId == _auth.currentUser?.uid &&
            (b.status == BookingStatus.accepted ||
                b.status == BookingStatus.onTheWay ||
                b.status == BookingStatus.inProgress),
      )
      .toList();

  List<Booking> get completedJobs => _items
      .where(
        (b) =>
            b.technicianId != null &&
            b.technicianId == _auth.currentUser?.uid &&
            b.status == BookingStatus.completed,
      )
      .toList();

  /// قبول الطلب بواسطة الفني وتحديد السعر النهائي
  /// يرجع false لو الطلب لم يعد pending (اتلغى أو اتقبل) أو فشل الاتصال.
  Future<bool> accept(
    Booking b, {
    required int proposedPrice,
    String technicianName = 'فني Fixly',
    String? technicianPhone,
  }) async {
    final techUid = _auth.currentUser?.uid;
    if (techUid == null) return false;

    try {
      await _db.runTransaction((tx) async {
        final ref = _collection.doc(b.id);
        final snap = await tx.get(ref);
        final data = snap.data() as Map<String, dynamic>?;
        if (data == null || data['status'] != BookingStatus.pending.name) {
          throw StateError('booking-not-pending');
        }
        tx.update(ref, {
          'status': BookingStatus.accepted.name,
          'technicianId': techUid,
          'technicianName': technicianName,
          'technicianPhone': technicianPhone ?? b.technicianPhone,
          'proposedPrice': proposedPrice,
          'price': proposedPrice,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      debugPrint('Error accepting booking: $e');
      return false;
    }

    b.status = BookingStatus.accepted;
    b.proposedPrice = proposedPrice;
    b.price = proposedPrice;
    b.technicianId = techUid;
    b.technicianName = technicianName;
    if (technicianPhone != null) b.technicianPhone = technicianPhone;
    notifyListeners();

    NotificationStore.instance.add(
      audience: NotificationAudience.customer,
      title: 'تم قبول طلبك وتحديد السعر',
      body: 'قبل الفني $technicianName طلبك وحدد السعر النهائي: $proposedPrice ج.م',
    );
    return true;
  }

  /// رفض الطلب بواسطة الفني
  Future<void> decline(Booking b) async {
    _declined.add(b.id);
    b.status = BookingStatus.rejected;
    notifyListeners();

    try {
      await _collection.doc(b.id).update({
        'status': BookingStatus.rejected.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error declining booking: $e');
    }

    NotificationStore.instance.add(
      audience: NotificationAudience.customer,
      title: 'تم رفض الطلب',
      body: 'اعتذر الفني عن قبول الطلب. يمكنك اختيار فني آخر متاح.',
    );
  }

  /// اختيار طريقة الدفع بواسطة العميل (كاش أو فيزا)
  Future<void> setPaymentMethod(
    Booking b, {
    required String method,
    bool isPaid = false,
  }) async {
    b.paymentMethod = method;
    b.paymentStatus = isPaid ? 'paid' : 'pending';
    notifyListeners();

    try {
      await _collection.doc(b.id).update({
        'paymentMethod': method,
        'paymentStatus': b.paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating payment method: $e');
    }
  }

  /// تقدم مراحل العمل
  Future<void> advance(Booking b, {int? price}) async {
    BookingStatus nextStatus;
    String title;
    String body;

    switch (b.status) {
      case BookingStatus.accepted:
        nextStatus = BookingStatus.onTheWay;
        title = 'الفني في الطريق إليك';
        body = '${b.technicianName ?? 'الفني'} في طريقه إلى موقعك الآن.';
        break;
      case BookingStatus.onTheWay:
        nextStatus = BookingStatus.inProgress;
        title = 'بدء العمل';
        body = 'بدأ الفني بالعمل على صيانة: ${b.issue}';
        break;
      case BookingStatus.inProgress:
        nextStatus = BookingStatus.completed;
        title = 'تم إنجاز العمل بنجاح';
        body = 'يرجى تقييم الفني وسداد المبلغ المطلوب (${b.price ?? price ?? 0} ج.م)';
        break;
      default:
        return;
    }

    b.status = nextStatus;
    if (nextStatus == BookingStatus.completed && price != null) {
      b.price = price;
    }
    notifyListeners();

    try {
      final updateData = <String, dynamic>{
        'status': nextStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (nextStatus == BookingStatus.completed && price != null) {
        updateData['price'] = price;
      }
      await _collection.doc(b.id).update(updateData);
    } catch (e) {
      debugPrint('Error advancing booking: $e');
    }

    NotificationStore.instance.add(
      audience: NotificationAudience.customer,
      title: title,
      body: body,
    );
  }

  @override
  void dispose() {
    _clientSub?.cancel();
    _techSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
