import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceRequestStatus {
  pending,
  assigned,
  inProgress,
  completed,
  cancelled;

  String toFirestore() => name;

  static ServiceRequestStatus fromFirestore(String? v) {
    return ServiceRequestStatus.values.firstWhere(
      (e) => e.name == v,
      orElse: () => ServiceRequestStatus.pending,
    );
  }
}

/// Customer complaint / AI-assisted request that gets sent to technicians.
class ServiceRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String description;
  final String? imageUrl;
  final String? aiSummary;
  final String? category;
  final String? area;
  final String? technicianId;
  final ServiceRequestStatus status;
  final DateTime? createdAt;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.description,
    this.imageUrl,
    this.aiSummary,
    this.category,
    this.area,
    this.technicianId,
    required this.status,
    this.createdAt,
  });

  factory ServiceRequest.fromMap(Map<String, dynamic> map, String id) {
    return ServiceRequest(
      id: id,
      customerId: map['customerId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      customerPhone: map['customerPhone'] as String?,
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      aiSummary: map['aiSummary'] as String?,
      category: map['category'] as String?,
      area: map['area'] as String?,
      technicianId: map['technicianId'] as String?,
      status: ServiceRequestStatus.fromFirestore(map['status'] as String?),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'description': description,
      'imageUrl': imageUrl,
      'aiSummary': aiSummary,
      'category': category,
      'area': area,
      'technicianId': technicianId,
      'status': status.toFirestore(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
