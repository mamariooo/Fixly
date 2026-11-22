import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminAppFilterStatus { pending, approved, rejected }

class AdminTechApplication {
  final String docId;
  final String name;
  final String phone;
  final String skill;
  final String years;
  final String area;
  final String idPhoto;
  final AdminAppFilterStatus status;

  const AdminTechApplication({
    required this.docId,
    required this.name,
    required this.phone,
    required this.skill,
    required this.years,
    required this.area,
    required this.idPhoto,
    required this.status,
  });

  factory AdminTechApplication.fromDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawStatus = (data['status'] ?? 'pending_approval')
        .toString()
        .toLowerCase();

    final AdminAppFilterStatus parsedStatus;
    if (rawStatus == 'approved' || rawStatus == 'active') {
      parsedStatus = AdminAppFilterStatus.approved;
    } else if (rawStatus == 'rejected') {
      parsedStatus = AdminAppFilterStatus.rejected;
    } else {
      parsedStatus = AdminAppFilterStatus.pending;
    }

    return AdminTechApplication(
      docId: doc.id,
      name: (data['fullName'] ?? data['name'] ?? 'Technician').toString(),
      phone: (data['phone'] ?? '').toString(),
      skill: (data['skill'] ?? data['specialty'] ?? 'General').toString(),
      years: (data['years'] ?? 0).toString(),
      area: (data['area'] ?? '').toString(),
      idPhoto: (data['idPhotoName'] ?? data['idPhoto'] ?? 'N/A').toString(),
      status: parsedStatus,
    );
  }
}

class AdminDashboardMetrics {
  final int totalCustomers;
  final int totalTechnicians;
  final int activeJobs;
  final int completedJobs;
  final double totalRevenue;
  final String avgRating;
  final int satisfactionPct;
  final int ratedTechniciansCount;
  final Map<String, int> serviceCounts;
  final Map<String, int> areaCounts;

  const AdminDashboardMetrics({
    required this.totalCustomers,
    required this.totalTechnicians,
    required this.activeJobs,
    required this.completedJobs,
    required this.totalRevenue,
    required this.avgRating,
    required this.satisfactionPct,
    required this.ratedTechniciansCount,
    required this.serviceCounts,
    required this.areaCounts,
  });

  factory AdminDashboardMetrics.fromSnapshots({
    required List<QueryDocumentSnapshot> usersDocs,
    required List<QueryDocumentSnapshot> techDocs,
    required List<QueryDocumentSnapshot> reqDocs,
  }) {
    final totalCustomers = usersDocs.where((d) {
      final data = d.data() as Map<String, dynamic>? ?? {};
      return (data['isClient'] as bool?) ??
          (data['role']?.toString() == 'client');
    }).length;

    final totalTechnicians = techDocs.isNotEmpty
        ? techDocs.length
        : usersDocs.where((d) {
            final data = d.data() as Map<String, dynamic>? ?? {};
            return (data['isTechnician'] as bool?) ??
                (data['role']?.toString() == 'technician');
          }).length;

    int activeJobs = 0;
    int completedJobs = 0;
    double totalRevenue = 0;
    final Map<String, int> serviceCounts = {};
    final Map<String, int> areaCounts = {};

    for (final doc in reqDocs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final status = (data['status'] ?? '').toString().toLowerCase();
      if (status == 'completed' || status == 'done') {
        completedJobs++;
      } else if (status != 'cancelled' && status != 'rejected') {
        activeJobs++;
      }

      final price =
          (data['price'] as num?)?.toDouble() ??
          (data['totalAmount'] as num?)?.toDouble() ??
          0;
      totalRevenue += price;

      final service =
          (data['category'] ?? data['service'] ?? data['specialty'] ?? 'Other')
              .toString();
      serviceCounts[service] = (serviceCounts[service] ?? 0) + 1;

      final area = (data['area'] ?? data['location'] ?? '').toString();
      if (area.isNotEmpty) {
        areaCounts[area] = (areaCounts[area] ?? 0) + 1;
      }
    }

    double ratingSum = 0;
    int ratingCount = 0;
    for (final doc in techDocs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final r = (data['rating'] as num?)?.toDouble();
      if (r != null && r > 0) {
        ratingSum += r;
        ratingCount++;
      }
    }

    final avgRating = ratingCount > 0
        ? (ratingSum / ratingCount).toStringAsFixed(1)
        : '0.0';
    final satisfactionPct = ratingCount > 0
        ? ((ratingSum / (ratingCount * 5)) * 100).round()
        : 0;

    return AdminDashboardMetrics(
      totalCustomers: totalCustomers,
      totalTechnicians: totalTechnicians,
      activeJobs: activeJobs,
      completedJobs: completedJobs,
      totalRevenue: totalRevenue,
      avgRating: avgRating,
      satisfactionPct: satisfactionPct,
      ratedTechniciansCount: ratingCount,
      serviceCounts: serviceCounts,
      areaCounts: areaCounts,
    );
  }
}
