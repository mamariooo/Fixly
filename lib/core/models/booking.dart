import 'package:flutter/material.dart';

/// ترتيب الحالات مهم: بيتستخدم في شاشة التتبع.
enum BookingStatus {
  pending,
  accepted,
  onTheWay,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
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

  bool get isActive =>
      this != BookingStatus.completed && this != BookingStatus.cancelled;
}

class Booking {
  Booking({
    required this.id,
    required this.service,
    required this.issue,
    required this.urgency,
    required this.createdAt,
    this.address,
    this.paymentMethod,
    this.status = BookingStatus.pending,
    this.technicianName,
    this.price,
    this.rating,
  });

  final String id;
  final String service;
  final String issue;
  final String urgency;
  final DateTime createdAt;
  final String? address;
  final String? paymentMethod;

  BookingStatus status;
  String? technicianName;
  int? price;
  int? rating;

  IconData get icon {
    switch (service) {
      case 'Air Conditioning':
        return Icons.ac_unit;
      case 'Plumbing':
        return Icons.water_drop_outlined;
      case 'Electrical':
        return Icons.bolt;
      case 'Emergency':
        return Icons.warning_amber_rounded;
      case 'Appliance Repair':
        return Icons.settings_outlined;
      default:
        return Icons.build_outlined;
    }
  }
}
