import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'package:fixly/core/services/notification_store.dart';

/// شاشة الإشعارات (للعميل بالإنجليزي، وللفني بالعربي RTL)
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
    required this.audience,
    this.arabic = false,
  });

  final NotificationAudience audience;
  final bool arabic;

  TextStyle _t(double size, FontWeight w, Color c) => arabic
      ? GoogleFonts.cairo(fontSize: size, fontWeight: w, color: c)
      : GoogleFonts.manrope(fontSize: size, fontWeight: w, color: c);

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return arabic ? 'الآن' : 'Just now';
    if (d.inMinutes < 60) {
      return arabic ? 'منذ ${d.inMinutes} دقيقة' : '${d.inMinutes} min ago';
    }
    if (d.inHours < 24) {
      return arabic ? 'منذ ${d.inHours} ساعة' : '${d.inHours} h ago';
    }
    return arabic ? 'منذ ${d.inDays} يوم' : '${d.inDays} d ago';
  }

  Widget _tile(AppNotification n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.read ? Colors.white : const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: n.read ? Colors.transparent : kBlue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.title, style: _t(16, FontWeight.w800, kNavy)),
                const SizedBox(height: 2),
                Text(n.body, style: _t(14, FontWeight.w500, kNavy)),
                const SizedBox(height: 4),
                Text(_ago(n.createdAt), style: _t(12, FontWeight.w500, kGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: NotificationStore.instance,
            builder: (context, _) {
              final items = NotificationStore.instance.forAudience(audience);

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(bottom: BorderSide(color: kBorder, width: 0.8)),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: kBorder.withValues(alpha: 0.6)),
                            ),
                            child: const Icon(Icons.arrow_back, color: kNavy),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            arabic ? 'الإشعارات' : 'Notifications',
                            style: _t(22, FontWeight.w800, kNavy),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              NotificationStore.instance.markAllRead(audience),
                          child: Text(
                            arabic ? 'قراءة الكل' : 'Mark all read',
                            style: _t(13, FontWeight.w700, kBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.notifications_none,
                                    size: 48, color: kGrey),
                                const SizedBox(height: 12),
                                Text(
                                  arabic
                                      ? 'مفيش إشعارات لسه'
                                      : 'No notifications yet',
                                  style: _t(18, FontWeight.w800, kNavy),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => _tile(items[i]),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}