import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/firestore_paths.dart';
import '../models/service_request.dart';

/// Stores customer complaints / AI-assisted requests and notifies technicians.
class ServiceRequestStore {
  ServiceRequestStore({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference get _col =>
      _db.collection(FirestorePaths.serviceRequests);

  /// Create a new request from customer (with optional image + AI summary).
  Future<String> createRequest({
    required String customerId,
    required String customerName,
    String? customerPhone,
    required String description,
    String? imageUrl,
    String? aiSummary,
    String? category,
    String? area,
  }) async {
    final doc = _col.doc();
    final req = ServiceRequest(
      id: doc.id,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      description: description,
      imageUrl: imageUrl,
      aiSummary: aiSummary,
      category: category,
      area: area,
      status: ServiceRequestStatus.pending,
    );
    await doc.set(req.toMap());
    return doc.id;
  }

  Stream<List<ServiceRequest>> watchPending({String? area}) {
    Query q = _col.where('status', isEqualTo: 'pending');
    // Note: compound indexes may be needed for area filter in production.
    return q.snapshots().map((snap) {
      return snap.docs
          .map(
            (d) =>
                ServiceRequest.fromMap(d.data() as Map<String, dynamic>, d.id),
          )
          .toList();
    });
  }

  Stream<List<ServiceRequest>> watchForCustomer(String customerId) {
    return _col
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map(
                (d) => ServiceRequest.fromMap(
                  d.data() as Map<String, dynamic>,
                  d.id,
                ),
              )
              .toList();
        });
  }

  Future<void> assignToTechnician({
    required String requestId,
    required String technicianId,
  }) async {
    await _col.doc(requestId).update({
      'technicianId': technicianId,
      'status': ServiceRequestStatus.assigned.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
