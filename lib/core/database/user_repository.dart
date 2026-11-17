import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'firestore_paths.dart';

String normalizeEgyptPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('20') && digits.length == 12) {
    return '+$digits';
  }
  if (digits.startsWith('0') && digits.length == 11) {
    return '+2$digits';
  }
  if (digits.length == 10) {
    return '+20$digits';
  }
  return '+$digits';
}

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  CollectionReference get _users => _db.collection(FirestorePaths.users);
  CollectionReference get _techProfiles =>
      _db.collection(FirestorePaths.technicianProfiles);

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUser.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<bool> isPhoneTaken(String phone, {String? excludeUid}) async {
    final normalized = normalizeEgyptPhone(phone);
    final snap = await _users
        .where('phone', isEqualTo: normalized)
        .limit(2)
        .get();
    for (final doc in snap.docs) {
      if (excludeUid == null || doc.id != excludeUid) {
        return true;
      }
    }
    return false;
  }

  Future<bool> isEmailTaken(String email) async {
    final snap = await _users
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<AppUser?> findUserByPhone(String phone) async {
    final normalized = normalizeEgyptPhone(phone);
    final snap = await _users
        .where('phone', isEqualTo: normalized)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  /// ينشئ وثيقة مستخدم جديدة مع دعم الدور المزدوج (Dual Role)
  Future<void> createUserDoc({
    required User firebaseUser,
    required String fullName,
    String? phone,
    required UserRole role,
    required bool isProfileComplete,
    String? area,
    String? specialty,
  }) async {
    final existing = await _users.doc(firebaseUser.uid).get();
    if (existing.exists) {
      // إذا كان الحساب موجوداً بالفعل، نقوم بتحديث تسجيل الدخول
      await updateLastLogin(firebaseUser.uid);
      return;
    }

    if (phone != null && phone.trim().isNotEmpty) {
      final taken = await isPhoneTaken(phone);
      if (taken) {
        throw FirebaseAuthException(
          code: 'phone-already-in-use',
          message: 'رقم الهاتف مستخدم بالفعل في حساب آخر.',
        );
      }
    }

    final providers = firebaseUser.providerData
        .map((p) => p.providerId)
        .toSet()
        .toList();

    final isTech = role == UserRole.technician;
    final isAdminRole = role == UserRole.admin;

    final AccountStatus status;
    if (isTech) {
      status = AccountStatus.pendingApproval;
    } else {
      status = AccountStatus.active;
    }
    final normalizedPhone = (phone != null && phone.trim().isNotEmpty)
        ? normalizeEgyptPhone(phone)
        : null;
    final user = AppUser(
      uid: firebaseUser.uid,
      email: (firebaseUser.email ?? '').trim().toLowerCase(),
      fullName: fullName.trim(),
      phone: normalizedPhone,
      photoUrl: firebaseUser.photoURL,
      role: role,
      accountStatus: status,
      isProfileComplete: isProfileComplete,
      authProviders: providers,
      area: area?.trim(),
      isClient: !isAdminRole, // عميل افتراضياً ما عدا الأدمن
      isTechnician: isTech,
      activeRole: isTech ? UserRole.client : role,
      technicianSpecialty: specialty,
    );

    await _users.doc(firebaseUser.uid).set(user.toMap());

    if (isTech) {
      await _techProfiles.doc(firebaseUser.uid).set({
        'name': fullName.trim(),
        'fullName': fullName.trim(),
        'phone': normalizedPhone ?? '',
        'specialty': specialty ?? 'General',
        'area': area?.trim() ?? 'القاهرة',
        'rating': 0.0,
        'ratingCount': 0,
        'hourlyRate': 180,
        'isExpert': false,
        'isAvailable': false,
        'status': 'pending_approval',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  /// تفعيل دور الفني للمستخدم الحالي (ليصبح عميلاً وفنياً في نفس الوقت)
  /// تقديم طلب تفعيل دور الفني (يظل معلقاً حتى موافقة الأدمن)
  /// لا يتم تفعيل activeRole=technician إلا بعد الموافقة.
  Future<void> enableTechnicianRole(
    String uid, {
    required String specialty,
    String? bio,
    int? hourlyRate,
    bool isExpert = false,
    String? area,
  }) async {
    final updateData = <String, dynamic>{
      'isTechnician': true, // طلب مسجل
      'technicianSpecialty': specialty,
      'isExpert': isExpert,
      'hourlyRate': hourlyRate ?? 180,
      'accountStatus': AccountStatus.pendingApproval.toFirestore(),
      // نبقي activeRole على client حتى الموافقة
      'activeRole': UserRole.client.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (bio != null) updateData['bio'] = bio;
    if (area != null) updateData['area'] = area;

    await _users.doc(uid).set(updateData, SetOptions(merge: true));

    // إضافة إلى جدول الفنيين كـ pending (الأدمن يرى الطلب)
    final userDoc = await _users.doc(uid).get();
    final name = (userDoc.data() as Map?)?['fullName'] ?? 'فني Fixly';
    final phone = (userDoc.data() as Map?)?['phone'] ?? '';

    await _techProfiles.doc(uid).set({
      'name': name,
      'fullName': name,
      'phone': phone,
      'specialty': specialty,
      'bio': bio ?? '',
      'isExpert': isExpert,
      'hourlyRate': hourlyRate ?? 180,
      'area': area ?? 'القاهرة',
      'rating': 0.0,
      'ratingCount': 0,
      'isAvailable': false,
      'status': 'pending_approval',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// التبديل السريع بين وضع العميل ووضع الفني (مع حماية الموافقة)
  Future<void> switchActiveRole(String uid, UserRole newRole) async {
    if (newRole == UserRole.technician) {
      final user = await getUserById(uid);
      if (user == null ||
          !user.isTechnician ||
          user.accountStatus != AccountStatus.active) {
        throw Exception(
          'Cannot switch to technician mode: account is pending approval or not approved.',
        );
      }
    }
    await _users.doc(uid).set({
      'activeRole': newRole.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateLastLogin(String uid) async {
    await _users.doc(uid).set({
      'lastLoginAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> completeProfileOnly({
    required String uid,
    String? phone,
    String? fullName,
    String? area,
  }) async {
    final data = <String, dynamic>{
      'isProfileComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (phone != null && phone.trim().isNotEmpty) {
      data['phone'] = normalizeEgyptPhone(phone);
    }
    if (fullName != null && fullName.trim().isNotEmpty) {
      data['fullName'] = fullName.trim();
    }
    if (area != null && area.trim().isNotEmpty) {
      data['area'] = area.trim();
    }
    await _users.doc(uid).set(data, SetOptions(merge: true));
  }
}
