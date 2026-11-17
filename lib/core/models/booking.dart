import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// حالات الطلب والحجز (Booking & Order Statuses)
enum BookingStatus {
  pending, // بانتظار رد الفني
  accepted, // قبل الفني الطلب وحدد السعر النهائي
  rejected, // رفض الفني الطلب
  onTheWay, // الفني في الطريق
  inProgress, // جاري العمل
  completed, // تم الانتهاء بنجاح
  cancelled, // تم الإلغاء
}

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.rejected:
        return 'Rejected';
      case BookingStatus.onTheWay:
        return 'On the way';
      case BookingStatus.inProgress:
        return 'In progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get labelAr {
    switch (this) {
      case BookingStatus.pending:
        return 'بانتظار الفني';
      case BookingStatus.accepted:
        return 'تم القبول وتحديد السعر';
      case BookingStatus.rejected:
        return 'تم الرفض';
      case BookingStatus.onTheWay:
        return 'الفني في الطريق';
      case BookingStatus.inProgress:
        return 'جاري العمل';
      case BookingStatus.completed:
        return 'مكتمل';
      case BookingStatus.cancelled:
        return 'ملغي';
    }
  }

  bool get isActive =>
      this != BookingStatus.completed &&
      this != BookingStatus.cancelled &&
      this != BookingStatus.rejected;
}

class Booking {
  Booking({
    required this.id,
    required this.service,
    required this.issue,
    required this.urgency,
    required this.createdAt,
    this.clientId,
    this.clientName,
    this.clientPhone,
    this.technicianId,
    this.technicianName,
    this.technicianPhone,
    this.address,
    this.aiSummary,
    this.needsExpert = false,
    this.photoUrls = const [],
    this.proposedPrice,
    this.price,
    this.paymentMethod,
    this.paymentStatus = 'pending',
    this.status = BookingStatus.pending,
    this.rating,
  });

  final String id;
  final String service;
  final String issue;
  final String urgency;
  final DateTime createdAt;
  final String? clientId;
  final String? clientName;
  final String? clientPhone;
  String? technicianId;
  String? technicianName;
  String? technicianPhone;
  final String? address;
  final String? aiSummary;
  final bool needsExpert;
  final List<String> photoUrls;
  int? proposedPrice; // السعر المحدد بواسطة الفني
  int? price; // السعر النهائي المتفق عليه
  String? paymentMethod; // 'Cash' أو 'Visa'
  String paymentStatus; // 'pending' أو 'paid'
  BookingStatus status;
  int? rating;

  IconData get icon {
    switch (service) {
      case 'Air Conditioning':
      case 'تكييف':
        return Icons.ac_unit;
      case 'Plumbing':
      case 'سباكة':
        return Icons.water_drop_outlined;
      case 'Electrical':
      case 'كهرباء':
        return Icons.bolt;
      case 'Emergency':
      case 'طوارئ':
        return Icons.warning_amber_rounded;
      case 'Appliance Repair':
      case 'أجهزة منزلية':
        return Icons.settings_outlined;
      case 'Carpentry':
      case 'نجارة':
        return Icons.hardware;
      default:
        return Icons.build_outlined;
    }
  }

  factory Booking.fromMap(Map<String, dynamic> map, String docId) {
    final rawStatus = map['status'] as String?;
    final status = BookingStatus.values.firstWhere(
      (e) => e.name == rawStatus,
      orElse: () => BookingStatus.pending,
    );

    final rawCreated = map['createdAt'];
    final createdAt = rawCreated is Timestamp
        ? rawCreated.toDate()
        : (rawCreated is DateTime ? rawCreated : DateTime.now());

    final photos = (map['photoUrls'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        (map['imageUrl'] != null ? [map['imageUrl'].toString()] : const <String>[]);

    final priceVal = (map['price'] as num?)?.toInt();
    final proposedVal = (map['proposedPrice'] as num?)?.toInt() ?? priceVal;

    return Booking(
      id: docId,
      service: (map['service'] as String?) ?? (map['category'] as String?) ?? 'General',
      issue: (map['issue'] as String?) ?? (map['description'] as String?) ?? '',
      urgency: (map['urgency'] as String?) ?? 'Medium',
      createdAt: createdAt,
      clientId: map['clientId'] as String? ?? map['customerId'] as String?,
      clientName: map['clientName'] as String? ?? map['customerName'] as String?,
      clientPhone: map['clientPhone'] as String? ?? map['customerPhone'] as String?,
      technicianId: map['technicianId'] as String?,
      technicianName: map['technicianName'] as String?,
      technicianPhone: map['technicianPhone'] as String?,
      address: map['address'] as String? ?? map['area'] as String?,
      aiSummary: map['aiSummary'] as String?,
      needsExpert: (map['needsExpert'] as bool?) ?? false,
      photoUrls: photos,
      proposedPrice: proposedVal,
      price: priceVal ?? proposedVal,
      paymentMethod: map['paymentMethod'] as String?,
      paymentStatus: (map['paymentStatus'] as String?) ?? 'pending',
      status: status,
      rating: (map['rating'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service': service,
      'category': service,
      'issue': issue,
      'description': issue,
      'urgency': urgency,
      'createdAt': Timestamp.fromDate(createdAt),
      'clientId': clientId,
      'customerId': clientId,
      'clientName': clientName,
      'customerName': clientName,
      'clientPhone': clientPhone,
      'customerPhone': clientPhone,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'technicianPhone': technicianPhone,
      'address': address,
      'area': address,
      'aiSummary': aiSummary,
      'needsExpert': needsExpert,
      'photoUrls': photoUrls,
      'imageUrl': photoUrls.isNotEmpty ? photoUrls.first : null,
      'proposedPrice': proposedPrice ?? price,
      'price': price ?? proposedPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status.name,
      'rating': rating,
    };
  }
}
