import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/notification_store.dart';
import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'page_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  BoxDecoration get _box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: kBorder.withValues(alpha: 0.7)),
  );

  TextStyle _title() => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: kNavy,
  );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // الإشعارات
          ListenableBuilder(
            listenable: NotificationStore.instance,
            builder: (context, _) => Container(
              decoration: _box,
              child: SwitchListTile(
                value: NotificationStore.instance.customerEnabled,
                onChanged: NotificationStore.instance.setCustomerEnabled,
                title: Text('Notifications', style: _title()),
                subtitle: Text(
                  'Updates about your bookings',
                  style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // اللغة
          ValueListenableBuilder(
            valueListenable: appLocale,
            builder: (context, locale, _) => Container(
              padding: const EdgeInsets.all(16),
              decoration: _box,
              child: Row(
                children: [
                  Expanded(child: Text('Language', style: _title())),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'en', label: Text('EN')),
                      ButtonSegment(value: 'ar', label: Text('AR')),
                    ],
                    selected: {locale.languageCode == 'ar' ? 'ar' : 'en'},
                    onSelectionChanged: (s) => changeLanguage(s.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // عن التطبيق
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _box,
            child: Row(
              children: [
                Expanded(child: Text('About Fixly', style: _title())),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
