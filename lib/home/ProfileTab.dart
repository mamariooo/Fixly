import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixly/Login/Login.dart';

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
  // بيانات تجريبية: استبدلها ببيانات المستخدم الحقيقية
  final String _name = 'Mario Wageh';
  final String _phone = '+20 1153 14 5920';

  String _language = 'EN';

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
  }

  void _logout() {
    // TODO: امسح بيانات الجلسة/التوكن هنا
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
          Divider(height: 1, thickness: 1, color: kBorder.withOpacity(0.5)),
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kBorder.withOpacity(0.7)),
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
          // TODO: غيّر لغة التطبيق هنا (Locale)
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
        border: Border.all(color: kBorder.withOpacity(0.8)),
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
                _phone,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kGrey,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  // TODO: open edit profile
                },
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
              onTap: () {/* TODO */},
            ),
            _tile(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              onTap: () {/* TODO */},
            ),
            _tile(
              icon: Icons.history,
              title: 'Service History',
              onTap: () {/* TODO */},
            ),
            _tile(
              icon: Icons.favorite_border,
              title: 'Favorites',
              onTap: () {/* TODO */},
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 24),

          _card([
            _tile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () {/* TODO */},
            ),
            _tile(
              icon: Icons.language,
              title: 'Language',
              trailing: _languageToggle(),
            ),
            _tile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {/* TODO */},
            ),
            _tile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {/* TODO */},
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