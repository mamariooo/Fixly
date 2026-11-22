import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Login/Login.dart';
import '../core/database/firestore_paths.dart';
import '../core/database/user_repository.dart';
import '../core/models/app_user.dart';
import '../core/services/auth_service.dart';
import '../core/services/notification_store.dart';
import '../core/utils/validators.dart';
import '../main.dart';
import 'Dashboard_Technician/technician_home_screen.dart'
    hide kNavy, kGrey, kBg, kBorder, kBlue;
import '../core/utils/address_dialog.dart';
import 'Profile_pages.dart';
import 'notification_screen.dart';

const Color _iconBg = Color(0xFFDCE9FF);
const Color _avatarText = Color(0xFF1B4FA8);
const Color _redBg = Color(0xFFFDE2E1);
const Color _redText = Color(0xFFB42318);
const Color _chevron = Color(0xFF8A94A6);

/// تاب "Profile" (بيتحط جوه الـ Bottom Nav في HomeScreen)
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _authService = AuthService();
  final UserRepository _userRepo = UserRepository();

  String _name = 'Client';
  String _phone = '';
  bool _isTechnician = false;
  bool _canOperateTech = false;
  bool _techPending = false;

  String get _phoneDisplay {
    if (_phone.isEmpty) return 'No phone added';
    final digits = _phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('20') && digits.length == 12) {
      return '+20 ${digits.substring(2)}';
    }
    return '+20 ${digits.replaceFirst(RegExp(r'^0'), '')}';
  }

  String _language = appLocale.value.languageCode == 'ar' ? 'AR' : 'EN';

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    final result = parts
        .take(2)
        .map((p) => p.isEmpty ? '' : p[0].toUpperCase())
        .join();
    return result.isEmpty ? 'U' : result;
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      setState(() => _name = user.displayName!.trim());
    }

    final appUser = await _userRepo.getUserById(user.uid);
    if (!mounted || appUser == null) return;

    setState(() {
      if (appUser.fullName.trim().isNotEmpty) {
        _name = appUser.fullName.trim();
      }
      if (appUser.phone != null && appUser.phone!.trim().isNotEmpty) {
        _phone = appUser.phone!.trim();
      }
      _isTechnician = appUser.isTechnician;
      _canOperateTech = appUser.canOperateAsTechnician;
      _techPending = appUser.isPendingTechnician;
    });
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _comingSoon(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title is coming soon')));
  }

  Future<void> _showActivateTechnicianModal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String selectedSpecialty = 'Air Conditioning';
    bool isExpert = false;
    final rateCtrl = TextEditingController(text: '200');

    final specialties = [
      ('Air Conditioning', 'تكييف'),
      ('Plumbing', 'سباكة'),
      ('Electrical', 'كهرباء'),
      ('Appliances', 'أجهزة منزلية'),
      ('Carpentry', 'نجارة'),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              20,
              24,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'انضم كفني في Fixly (حساب مزدوج)',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'يمكنك الآن العمل كفني وطلب خدمات كعميل من نفس الحساب بسهولة!',
                  style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                ),
                const SizedBox(height: 18),
                Text(
                  'اختر تخصصك الأساسي:',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedSpecialty,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: specialties
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.$1,
                          child: Text('${s.$2} (${s.$1})'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setLocal(() => selectedSpecialty = v);
                  },
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'خبير معتمد (خبرة أكثر من 10 سنوات)',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  value: isExpert,
                  onChanged: (v) => setLocal(() => isExpert = v),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: rateCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'سعر الساعة / الكشف المبدئي (ج.م)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      final r = int.tryParse(rateCtrl.text.trim()) ?? 180;
                      await _userRepo.enableTechnicianRole(
                        user.uid,
                        specialty: selectedSpecialty,
                        isExpert: isExpert,
                        hourlyRate: r,
                      );
                      setState(() {
                        _isTechnician = true;
                        _techPending = true;
                        _canOperateTech = false;
                      });
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم إرسال طلبك. هتقدر تدخل وضع الفني بعد موافقة الأدمن.',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'تفعيل حساب الفني والبدء الآن',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final nameCtrl = TextEditingController(text: _name);
    final rawPhoneDigits = _phone.replaceAll(RegExp(r'^\+?20'), '');
    final phoneCtrl = TextEditingController(text: rawPhoneDigits);
    String? nameError;
    String? phoneError;
    bool saving = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Edit profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  errorText: nameError,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixText: '+20 ',
                  errorText: phoneError,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: saving
                  ? null
                  : () async {
                      final n = Validators.fullName(nameCtrl.text);
                      final p = Validators.phone(phoneCtrl.text);
                      if (n != null || p != null) {
                        setLocal(() {
                          nameError = n;
                          phoneError = p;
                        });
                        return;
                      }

                      final cleanPhone = phoneCtrl.text.replaceAll(
                        RegExp(r'[\s\-]'),
                        '',
                      );
                      setLocal(() => saving = true);

                      try {
                        final taken = await _userRepo.isPhoneTaken(
                          cleanPhone,
                          excludeUid: user.uid,
                        );
                        if (taken) {
                          setLocal(() {
                            saving = false;
                            phoneError =
                                'This phone number is already registered';
                          });
                          return;
                        }

                        final newName = nameCtrl.text.trim();
                        final normalizedPhone = normalizeEgyptPhone(cleanPhone);

                        await FirebaseFirestore.instance
                            .collection(FirestorePaths.users)
                            .doc(user.uid)
                            .set({
                              'fullName': newName,
                              'phone': normalizedPhone,
                              'updatedAt': FieldValue.serverTimestamp(),
                            }, SetOptions(merge: true));

                        await user.updateDisplayName(newName);

                        if (!mounted) return;
                        setState(() {
                          _name = newName;
                          _phone = normalizedPhone;
                        });
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        setLocal(() {
                          saving = false;
                          phoneError = 'Failed to update profile';
                        });
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );

    disposeLater([nameCtrl, phoneCtrl]);
  }

  // ---------- Pieces ----------
  Widget _iconBox(IconData icon, {Color bg = _iconBg, Color fg = kBlue}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: fg, size: 24),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
    bool showChevron = true,
    Color iconBg = _iconBg,
    Color iconFg = kBlue,
    Color titleColor = kNavy,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            child: Row(
              children: [
                _iconBox(icon, bg: iconBg, fg: iconFg),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (showChevron)
                  const Icon(Icons.chevron_right, color: _chevron, size: 28),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: kBorder.withValues(alpha: 0.5),
          ),
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _languageToggle() {
    Widget option(String code) {
      final selected = _language == code;
      return GestureDetector(
        onTap: () {
          setState(() => _language = code);
          changeLanguage(code.toLowerCase());
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            code,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : kGrey,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: kBorder.withValues(alpha: 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [option('EN'), option('AR')],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 120,
          height: 120,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: _iconBg,
            shape: BoxShape.circle,
          ),
          child: Text(
            _initials,
            style: GoogleFonts.manrope(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: _avatarText,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: GoogleFonts.manrope(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _phoneDisplay,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kGrey,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _editProfile,
                child: Text(
                  'Edit profile',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 20),

          // كارت التبديل بين وضع العميل ووضع الفني (Dual Role)
          _card([
            if (_isTechnician && _canOperateTech)
              _tile(
                icon: Icons.swap_horiz,
                title: 'التبديل إلى وضع الفني (استقبال الطلبات والأرباح)',
                iconBg: const Color(0xFFDCE9FF),
                iconFg: const Color(0xFF1B4FA8),
                titleColor: const Color(0xFF1B4FA8),
                showDivider: false,
                onTap: () async {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    try {
                      await _userRepo.switchActiveRole(
                        uid,
                        UserRole.technician,
                      );
                    } catch (_) {
                      return;
                    }
                  }
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TechnicianHomeScreen(),
                    ),
                  );
                },
              )
            else if (_isTechnician)
              _tile(
                icon: Icons.hourglass_top,
                title: _techPending
                    ? 'طلب الانضمام كفني قيد المراجعة'
                    : 'طلب الانضمام كفني غير مفعّل',
                iconBg: const Color(0xFFFFF3D6),
                iconFg: const Color(0xFF8A5300),
                titleColor: const Color(0xFF8A5300),
                showDivider: false,
                onTap: () {},
              )
            else
              _tile(
                icon: Icons.handyman_outlined,
                title: 'انضم كفني في Fixly (حساب مزدوج)',
                iconBg: const Color(0xFFFFF3D6),
                iconFg: const Color(0xFF8A5300),
                titleColor: const Color(0xFF8A5300),
                showDivider: false,
                onTap: _showActivateTechnicianModal,
              ),
          ]),
          const SizedBox(height: 20),

          _card([
            _tile(
              icon: Icons.location_on_outlined,
              title: 'Saved Locations',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedLocationsScreen()),
              ),
            ),
            _tile(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
              ),
            ),
            _tile(
              icon: Icons.history,
              title: 'Service History',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceHistoryScreen()),
              ),
            ),
            _tile(
              icon: Icons.favorite_border,
              title: 'Favorites',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 24),

          _card([
            _tile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(
                    audience: NotificationAudience.customer,
                  ),
                ),
              ),
            ),
            _tile(
              icon: Icons.language,
              title: 'Language',
              trailing: _languageToggle(),
            ),
            _tile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            _tile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              ),
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 24),

          _card([
            _tile(
              icon: Icons.logout,
              title: 'Logout',
              iconBg: _redBg,
              iconFg: _redText,
              titleColor: _redText,
              showChevron: false,
              showDivider: false,
              onTap: _logout,
            ),
          ]),
        ],
      ),
    );
  }
}