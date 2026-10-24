import 'package:flutter/material.dart';

import 'package:fixly/main.dart' show appLocale, changeLanguage;
import 'package:fixly/Splash/welcome_to_fixly.dart';
import 'admin_ai_monitoring.dart';
import 'admin_dashboard.dart';
import 'admin_theme.dart';

enum AdminPage { dashboard, aiMonitoring }

class _NavItem {
  final IconData icon;
  final String en;
  final String ar;
  final AdminPage? page; // null → "Not part of this prototype"
  final bool accent;

  const _NavItem(this.icon, this.en, this.ar, this.page, {this.accent = false});
}

const _navItems = <_NavItem>[
  _NavItem(Icons.grid_view_rounded, 'Dashboard', 'لوحة التحكم', AdminPage.dashboard),
  _NavItem(Icons.person_outline_rounded, 'Customers', 'العملاء', null),
  _NavItem(Icons.build_outlined, 'Technicians', 'الفنيون', null),
  _NavItem(Icons.calendar_today_outlined, 'Bookings', 'الحجوزات', null),
  _NavItem(Icons.format_list_bulleted_rounded, 'Services', 'الخدمات', null),
  _NavItem(Icons.warning_amber_rounded, 'Complaints', 'الشكاوى', null),
  _NavItem(Icons.payments_outlined, 'Payments', 'المدفوعات', null),
  _NavItem(Icons.star_outline_rounded, 'Reviews', 'التقييمات', null),
  _NavItem(Icons.bar_chart_rounded, 'Analytics', 'التحليلات', null),
  _NavItem(Icons.auto_awesome_outlined, 'AI Monitoring', 'مراقبة الذكاء الاصطناعي',
      AdminPage.aiMonitoring,
      accent: true),
  _NavItem(Icons.settings_outlined, 'Settings', 'الإعدادات', null),
];

/// Admin shell: sidebar (permanent on wide screens, drawer on narrow ones)
/// + the currently selected page.
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AdminPage _page = AdminPage.dashboard;

  void _select(AdminPage page) {
    setState(() => _page = page);
    // Close the drawer when it is open (narrow layout).
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcometoFixly()),
      (route) => false,
    );
  }

  Widget _sidebar() {
    return Container(
      color: A.navy,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 20),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.build_rounded, color: A.navy, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text('Fixly',
                        style: aText(20, color: Colors.white, letterSpacing: -0.4)),
                    const SizedBox(width: 8),
                    Text('ADMIN',
                        style: aText(10,
                            weight: FontWeight.w800,
                            color: A.cyan,
                            letterSpacing: 1)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (final item in _navItems)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _SideTile(
                          icon: item.icon,
                          label: tr(item.en, item.ar),
                          active: item.page != null && item.page == _page,
                          iconColor: item.accent ? A.cyan : null,
                          onTap: () {
                            if (item.page != null) {
                              _select(item.page!);
                            } else {
                              showAdminToast(
                                context,
                                tr('Not part of this prototype',
                                    'غير متاحة في هذه النسخة التجريبية'),
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
              _SideTile(
                icon: Icons.logout_rounded,
                label: tr('Sign out', 'تسجيل الخروج'),
                active: false,
                color: A.signOut,
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, _, __) {
        return LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;

            final content = _page == AdminPage.dashboard
                ? AdminDashboardPage(
                    onOpenMenu: wide ? null : () => _scaffoldKey.currentState?.openDrawer(),
                  )
                : AdminAiMonitoringPage(
                    onOpenMenu: wide ? null : () => _scaffoldKey.currentState?.openDrawer(),
                  );

            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: A.bg,
              drawer: wide
                  ? null
                  : Drawer(
                      width: 280,
                      backgroundColor: A.navy,
                      shape: const RoundedRectangleBorder(),
                      child: _sidebar(),
                    ),
              body: wide
                  ? Row(
                      children: [
                        SizedBox(width: 260, child: _sidebar()),
                        Expanded(child: SafeArea(child: content)),
                      ],
                    )
                  : SafeArea(child: content),
            );
          },
        );
      },
    );
  }
}

class _SideTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color? color;
  final Color? iconColor;
  final VoidCallback onTap;

  const _SideTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = color ?? (active ? Colors.white : A.sideItem);
    return Material(
      color: active ? A.sideActive : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor ?? fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: aText(14, color: fg),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared page header: menu button (narrow), title/subtitle, extra widgets,
/// and the EN | AR switch.
class AdminPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onOpenMenu;
  final List<Widget> actions;

  const AdminPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onOpenMenu,
    this.actions = const [],
  });

  Widget _menuButton() => Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: A.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onOpenMenu,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.menu_rounded, color: A.navy),
          ),
        ),
      );

  Widget _titles() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: aText(28,
                  weight: FontWeight.w800, height: 1.3, letterSpacing: -0.5)),
          Text(subtitle,
              style: aText(14, weight: FontWeight.w600, color: A.grey)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        // Wide: title on the left, controls pushed to the end (like the mockup).
        if (c.maxWidth >= 820) {
          return Row(
            children: [
              Expanded(child: _titles()),
              for (final a in actions) ...[const SizedBox(width: 16), a],
              const SizedBox(width: 16),
              const LanguageToggle(),
            ],
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (onOpenMenu != null) _menuButton(),
            const LanguageToggle(),
            SizedBox(width: c.maxWidth, child: _titles()),
            ...actions,
          ],
        );
      },
    );
  }
}

/// "EN | AR" pill, wired to the app-wide language switch.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, String code) {
      final on = appLocale.value.languageCode == code;
      return GestureDetector(
        onTap: () => changeLanguage(code),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: on ? A.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: aText(12, weight: FontWeight.w800, color: on ? Colors.white : A.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: A.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [seg('EN', 'en'), seg('AR', 'ar')],
      ),
    );
  }
}

/// White rounded "pill" box used for the period selector.
class HeaderPill extends StatelessWidget {
  final String text;
  const HeaderPill(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: A.border),
      ),
      child: Text(text, style: aText(14)),
    );
  }
}
