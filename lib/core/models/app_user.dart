import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  client,
  technician,
  admin;

  String toJson() => name;

  static UserRole fromJson(String? value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.client,
    );
  }
}

enum AccountStatus {
  pendingApproval,
  active,
  rejected,
  suspended;

  String toFirestore() {
    switch (this) {
      case AccountStatus.pendingApproval:
        return 'pending_approval';
      case AccountStatus.active:
        return 'active';
      case AccountStatus.rejected:
        return 'rejected';
      case AccountStatus.suspended:
        return 'suspended';
    }
  }

  static AccountStatus fromFirestore(String? value) {
    switch (value) {
      case 'pending_approval':
        return AccountStatus.pendingApproval;
      case 'rejected':
        return AccountStatus.rejected;
      case 'suspended':
        return AccountStatus.suspended;
      case 'active':
      default:
        return AccountStatus.active;
    }
  }
}

class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String? phone;
  final String? photoUrl;
  final UserRole role; // الدور الأساسي أو الحالي
  final AccountStatus accountStatus;
  final bool isProfileComplete;
  final List<String> authProviders;
  final String? area;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  // ===== إضافات دعم العميل + الفني في نفس الوقت (Dual Role) =====
  final bool isClient; // هل الحساب مؤهل كعميل (افتراضي: true)
  final bool isTechnician; // هل الحساب مسجل أيضاً كفني
  final UserRole activeRole; // الوضع النشط حالياً (client أو technician)
  final String? technicianSpecialty; // تخصص الفني إن وجد (AC, Plumbing, etc.)
  final bool isExpert; // هل الفني خبير معتمد
  final double rating; // تقييم الفني
  final int ratingCount; // عدد التقييمات
  final int hourlyRate; // سعر الساعة / المصنعية التقديرية بالجنيه
  final String? bio; // نبذة عن الفني
  final double? latitude;
  final double? longitude;
  final bool isAvailable; // هل الفني متاح لاستقبال طلبات الآن

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.phone,
    this.photoUrl,
    required this.role,
    required this.accountStatus,
    required this.isProfileComplete,
    this.authProviders = const [],
    this.area,
    this.createdAt,
    this.lastLoginAt,
    this.isClient = true,
    this.isTechnician = false,
    this.activeRole = UserRole.client,
    this.technicianSpecialty,
    this.isExpert = false,
    this.rating = 4.8,
    this.ratingCount = 0,
    this.hourlyRate = 180,
    this.bio,
    this.latitude,
    this.longitude,
    this.isAvailable = true,
  });

  /// هل الحساب يدعم الدورين معاً (عميل وفني في نفس الوقت)
  bool get isDualRole => isClient && isTechnician;

  bool get canOperateAsClient => isClient;

  bool get canOperateAsTechnician =>
      isTechnician && accountStatus == AccountStatus.active;
  bool get isAdmin => role == UserRole.admin || activeRole == UserRole.admin;

  bool get isPendingTechnician =>
      isTechnician && accountStatus == AccountStatus.pendingApproval;
  AppUser copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    String? photoUrl,
    UserRole? role,
    AccountStatus? accountStatus,
    bool? isProfileComplete,
    List<String>? authProviders,
    String? area,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isClient,
    bool? isTechnician,
    UserRole? activeRole,
    String? technicianSpecialty,
    bool? isExpert,
    double? rating,
    int? ratingCount,
    int? hourlyRate,
    String? bio,
    double? latitude,
    double? longitude,
    bool? isAvailable,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      accountStatus: accountStatus ?? this.accountStatus,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      authProviders: authProviders ?? this.authProviders,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isClient: isClient ?? this.isClient,
      isTechnician: isTechnician ?? this.isTechnician,
      activeRole: activeRole ?? this.activeRole,
      technicianSpecialty: technicianSpecialty ?? this.technicianSpecialty,
      isExpert: isExpert ?? this.isExpert,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      bio: bio ?? this.bio,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String docId) {
    final role = UserRole.fromJson(map['role'] as String?);
    final activeRole = map['activeRole'] != null
        ? UserRole.fromJson(map['activeRole'] as String?)
        : role;

    final isTech =
        (map['isTechnician'] as bool?) ?? (role == UserRole.technician);
    final isCli = (map['isClient'] as bool?) ?? true;

    return AppUser(
      uid: (map['uid'] as String?) ?? docId,
      email: (map['email'] as String?) ?? '',
      fullName: (map['fullName'] as String?) ?? '',
      phone: map['phone'] as String?,
      photoUrl: map['photoUrl'] as String?,
      role: role,
      accountStatus: AccountStatus.fromFirestore(
        map['accountStatus'] as String?,
      ),
      isProfileComplete: (map['isProfileComplete'] as bool?) ?? false,
      authProviders: List<String>.from(map['authProviders'] ?? const []),
      area: map['area'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp?)?.toDate(),
      isClient: isCli,
      isTechnician: isTech,
      activeRole: activeRole,
      technicianSpecialty:
          map['technicianSpecialty'] as String? ?? map['specialty'] as String?,
      isExpert: (map['isExpert'] as bool?) ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      hourlyRate: (map['hourlyRate'] as num?)?.toInt() ?? 180,
      bio: map['bio'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      isAvailable: (map['isAvailable'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role.toJson(),
      'accountStatus': accountStatus.toFirestore(),
      'isProfileComplete': isProfileComplete,
      'authProviders': authProviders,
      'area': area,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'isClient': isClient,
      'isTechnician': isTechnician,
      'activeRole': activeRole.toJson(),
      'technicianSpecialty': technicianSpecialty,
      'isExpert': isExpert,
      'rating': rating,
      'ratingCount': ratingCount,
      'hourlyRate': hourlyRate,
      'bio': bio,
      'latitude': latitude,
      'longitude': longitude,
      'isAvailable': isAvailable,
    };
  }
}
