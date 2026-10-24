import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixly/Login/Login.dart';
<<<<<<< HEAD
import 'package:fixly/main.dart' show appLocale, changeLanguage;
import 'package:fixly/core/services/mock_session.dart';
import 'package:fixly/core/utils/validators.dart';
import 'Profile_pages.dart';
import 'notification_screen.dart';
import 'package:fixly/core/services/notification_store.dart';
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

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
<<<<<<< HEAD
  String _name = MockSession.name ?? 'Mario Wageh';
  String _phone = MockSession.phone ?? '1153145920'; // أرقام بس
  String get _phoneDisplay => '+20 ${_phone.replaceFirst(RegExp(r'^0'), '')}';

  String _language = appLocale.value.languageCode == 'ar' ? 'AR' : 'EN';
=======
  // بيانات تجريبية: استبدلها ببيانات المستخدم الحقيقية
  final String _name = 'Mario Wageh';
  final String _phone = '+20 1153 14 5920';

  String _language = 'EN';
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
  }

  void _logout() {
<<<<<<< HEAD
    MockSession.clear();
=======
    // TODO: امسح بيانات الجلسة/التوكن هنا
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

<<<<<<< HEAD
  void _comingSoon(String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title is coming soon')));
  }

  Future<void> _editProfile() async {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    String? nameError;
    String? phoneError;

    final saved = await showDialog<bool>(
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
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final n = Validators.fullName(nameCtrl.text);
                final p = Validators.phone(phoneCtrl.text);
                if (n != null || p != null) {
                  setLocal(() {
                    nameError = n;
                    phoneError = p;
                  });
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (saved == true && mounted) {
      setState(() {
        _name = nameCtrl.text.trim();
        _phone = phoneCtrl.text.replaceAll(RegExp(r'[\s\-]'), '');
      });
      MockSession.name = _name;
      MockSession.phone = _phone;
    }
  }

=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
          Divider(
            height: 1,
            thickness: 1,
            color: kBorder.withValues(alpha: 0.5),
          ),
=======
          Divider(height: 1, thickness: 1, color: kBorder.withOpacity(0.5)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
<<<<<<< HEAD
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
=======
        border: Border.all(color: kBorder.withOpacity(0.7)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
          changeLanguage(code.toLowerCase());
=======
          // TODO: غيّر لغة التطبيق هنا (Locale)
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
        border: Border.all(color: kBorder.withValues(alpha: 0.8)),
=======
        border: Border.all(color: kBorder.withOpacity(0.8)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                _phoneDisplay,
=======
                _phone,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kGrey,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
<<<<<<< HEAD
                onTap: _editProfile,
=======
                onTap: () {
                  // TODO: open edit profile
                },
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
          const SizedBox(height: 24),

          _card([
            _tile(
              icon: Icons.location_on_outlined,
              title: 'Saved Locations',
<<<<<<< HEAD
              onTap: () => _comingSoon('Saved Locations'),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            _tile(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
<<<<<<< HEAD
              onTap: () => _comingSoon('Payment Methods'),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            _tile(
              icon: Icons.history,
              title: 'Service History',
<<<<<<< HEAD
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceHistoryScreen()),
              ),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            _tile(
              icon: Icons.favorite_border,
              title: 'Favorites',
<<<<<<< HEAD
              onTap: () => _comingSoon('favorite_border'),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 24),

          _card([
            _tile(
              icon: Icons.notifications_none,
              title: 'Notifications',
<<<<<<< HEAD
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(
                    audience: NotificationAudience.customer,
                  ),
                ),
              ),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            _tile(
              icon: Icons.language,
              title: 'Language',
              trailing: _languageToggle(),
            ),
            _tile(
              icon: Icons.settings_outlined,
              title: 'Settings',
<<<<<<< HEAD
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
            _tile(
              icon: Icons.help_outline,
              title: 'Help & Support',
<<<<<<< HEAD
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              ),
=======
              onTap: () {/* TODO */},
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
}
=======
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
