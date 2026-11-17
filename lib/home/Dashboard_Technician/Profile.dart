import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Login/Login.dart';
import '../home.dart';
import '../../core/database/firestore_paths.dart';
import '../../core/database/user_repository.dart';
import '../../core/services/auth_service.dart';

const Color kProfileNavy = Color(0xFF1C3358);
const Color kProfileBg = Color(0xFFF5F7FB);
const Color kProfileGrey = Color(0xFF8492A6);
const Color kProfileBorder = Color(0xFFE5EAF1);
const Color kProfileCyan = Color(0xFF14B8D6);

class TechnicianProfileScreen extends StatefulWidget {
  const TechnicianProfileScreen({super.key});

  @override
  State<TechnicianProfileScreen> createState() =>
      _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState extends State<TechnicianProfileScreen> {
  final AuthService _authService = AuthService();
  final UserRepository _userRepo = UserRepository();

  String _name = 'أحمد محمد';
  String _specialty = 'فني صيانة';
  String _area = 'مدينة نصر، القاهرة';
  String _phone = '';
  String _email = '';
  double _rating = 4.8;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _email = user.email ?? '';
      if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
        _name = user.displayName!.trim();
      }
    });

    final appUser = await _userRepo.getUserById(user.uid);
    if (!mounted || appUser == null) return;

    setState(() {
      if (appUser.fullName.trim().isNotEmpty) {
        _name = appUser.fullName.trim();
      }
      if (appUser.area != null && appUser.area!.trim().isNotEmpty) {
        _area = appUser.area!.trim();
      }
      if (appUser.phone != null && appUser.phone!.trim().isNotEmpty) {
        _phone = appUser.phone!.trim();
      }
    });

    final techDoc = await FirebaseFirestore.instance
        .collection(FirestorePaths.technicianProfiles)
        .doc(user.uid)
        .get();
    if (!mounted || !techDoc.exists || techDoc.data() == null) return;

    final data = techDoc.data()!;
    setState(() {
      final spec = data['specialty'] as String?;
      if (spec != null && spec.trim().isNotEmpty) {
        _specialty = spec.trim();
      }
      final ratingNum = data['rating'] as num?;
      if (ratingNum != null) {
        _rating = ratingNum.toDouble();
      }
    });
  }

  TextStyle text(double size, FontWeight weight, Color color) {
    return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
  }

  Widget profileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kProfileBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7FB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor ?? kProfileCyan),
        ),
        title: Text(title, style: text(15, FontWeight.w700, kProfileNavy)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, style: text(12, FontWeight.w500, kProfileGrey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: kProfileGrey,
        ),
        onTap: onTap,
      ),
    );
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _editFieldDialog({
    required String title,
    required String fieldKey,
    required String initialValue,
    required bool isTechProfileField,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ctrl = TextEditingController(text: initialValue);
    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(title, style: text(18, FontWeight.w800, kProfileNavy)),
          content: TextField(
            controller: ctrl,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();

    if (saved == null || saved.isEmpty) return;

    final collection = isTechProfileField
        ? FirestorePaths.technicianProfiles
        : FirestorePaths.users;

    await FirebaseFirestore.instance.collection(collection).doc(uid).set({
      fieldKey: saved,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (fieldKey == 'fullName') {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(saved);
    }

    if (!mounted) return;
    setState(() {
      if (fieldKey == 'fullName') _name = saved;
      if (fieldKey == 'specialty') _specialty = saved;
      if (fieldKey == 'area') _area = saved;
      if (fieldKey == 'phone') _phone = saved;
    });
    showMessage('تم حفظ التعديلات');
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalSubtitle = _phone.isEmpty && _email.isEmpty
        ? 'الاسم ورقم الهاتف والبريد الإلكتروني'
        : [
            if (_phone.isNotEmpty) _phone,
            if (_email.isNotEmpty) _email,
          ].join(' · ');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kProfileBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('حسابي', style: text(22, FontWeight.w800, kProfileNavy)),
          actions: [
            IconButton(
              onPressed: () => showMessage('الإعدادات قريبًا'),
              icon: const Icon(Icons.settings_outlined, color: kProfileNavy),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // بطاقة بيانات الفني
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: kProfileNavy,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 43,
                        backgroundColor: Color(0xFFDCE9FF),
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: kProfileNavy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(_name, style: text(23, FontWeight.w800, Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      _specialty,
                      style: text(14, FontWeight.w500, Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F9D63),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'حساب فني',
                        style: text(12, FontWeight.w700, Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text('حسابك', style: text(20, FontWeight.w800, kProfileNavy)),
              const SizedBox(height: 14),

              profileItem(
                icon: Icons.swap_horiz,
                title: 'التبديل إلى وضع العميل',
                subtitle: 'استخدم Fixly كعميل لطلب فنيين وصيانة منزلك',
                iconColor: const Color(0xFF1B4FA8),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (r) => false,
                  );
                },
              ),

              profileItem(
                icon: Icons.person_outline,
                title: 'البيانات الشخصية',
                subtitle: personalSubtitle,
                onTap: () => _editFieldDialog(
                  title: 'الاسم الكامل',
                  fieldKey: 'fullName',
                  initialValue: _name,
                  isTechProfileField: false,
                ),
              ),

              profileItem(
                icon: Icons.build_outlined,
                title: 'التخصصات والخدمات',
                subtitle: _specialty,
                onTap: () => _editFieldDialog(
                  title: 'التخصص',
                  fieldKey: 'specialty',
                  initialValue: _specialty,
                  isTechProfileField: true,
                ),
              ),

              profileItem(
                icon: Icons.location_on_outlined,
                title: 'منطقة الخدمة',
                subtitle: _area,
                onTap: () => _editFieldDialog(
                  title: 'منطقة الخدمة',
                  fieldKey: 'area',
                  initialValue: _area,
                  isTechProfileField: false,
                ),
              ),

              profileItem(
                icon: Icons.star_outline,
                title: 'التقييمات',
                subtitle: 'تقييمك الحالي ${_rating.toStringAsFixed(1)}',
                onTap: () =>
                    showMessage('تقييمك الحالي ${_rating.toStringAsFixed(1)}'),
              ),

              const SizedBox(height: 12),

              Text(
                'الإعدادات والدعم',
                style: text(20, FontWeight.w800, kProfileNavy),
              ),
              const SizedBox(height: 14),

              profileItem(
                icon: Icons.notifications_none,
                title: 'الإشعارات',
                subtitle: 'إدارة تنبيهات الطلبات',
                onTap: () => showMessage('إعدادات الإشعارات قريبًا'),
              ),

              profileItem(
                icon: Icons.lock_outline,
                title: 'الخصوصية والأمان',
                subtitle: 'إدارة كلمة المرور وأمان الحساب',
                onTap: () => showMessage('إعدادات الخصوصية قريبًا'),
              ),

              profileItem(
                icon: Icons.help_outline,
                title: 'المساعدة والدعم',
                subtitle: 'تواصل مع فريق Fixly',
                onTap: () => showMessage('صفحة الدعم قريبًا'),
              ),

              profileItem(
                icon: Icons.info_outline,
                title: 'عن Fixly',
                subtitle: 'معلومات عن التطبيق',
                onTap: () => showMessage('Fixly - خدمات الصيانة المنزلية'),
              ),

              const SizedBox(height: 12),

              // تسجيل الخروج
              profileItem(
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                iconColor: Colors.red,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: Text(
                            'تسجيل الخروج',
                            style: text(20, FontWeight.w800, kProfileNavy),
                          ),
                          content: Text(
                            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                            style: text(14, FontWeight.w500, kProfileGrey),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Text(
                                'إلغاء',
                                style: text(14, FontWeight.w700, kProfileGrey),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                await _logout();
                              },
                              child: Text(
                                'تأكيد',
                                style: text(14, FontWeight.w800, Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
