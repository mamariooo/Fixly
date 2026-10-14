
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kProfileNavy = Color(0xFF1C3358);
const Color kProfileBg = Color(0xFFF5F7FB);
const Color kProfileGrey = Color(0xFF8492A6);
const Color kProfileBorder = Color(0xFFE5EAF1);
const Color kProfileCyan = Color(0xFF14B8D6);

class TechnicianProfileScreen extends StatelessWidget {
  const TechnicianProfileScreen({super.key});

  TextStyle text(double size, FontWeight weight, Color color) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7FB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor ?? kProfileCyan),
        ),
        title: Text(
          title,
          style: text(15, FontWeight.w700, kProfileNavy),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: text(12, FontWeight.w500, kProfileGrey),
              ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: kProfileGrey,
        ),
        onTap: onTap,
      ),
    );
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kProfileBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'حسابي',
            style: text(22, FontWeight.w800, kProfileNavy),
          ),
          actions: [
            IconButton(
              onPressed: () => showMessage(context, 'الإعدادات قريبًا'),
              icon: const Icon(
                Icons.settings_outlined,
                color: kProfileNavy,
              ),
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
                        border: Border.all(
                          color: Colors.white54,
                          width: 2,
                        ),
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
                    Text(
                      'أحمد محمد',
                      style: text(23, FontWeight.w800, Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'فني صيانة',
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

              Text(
                'حسابك',
                style: text(20, FontWeight.w800, kProfileNavy),
              ),
              const SizedBox(height: 14),

              profileItem(
                icon: Icons.person_outline,
                title: 'البيانات الشخصية',
                subtitle: 'الاسم ورقم الهاتف والبريد الإلكتروني',
                onTap: () => showMessage(
                  context,
                  'صفحة تعديل البيانات الشخصية قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.build_outlined,
                title: 'التخصصات والخدمات',
                subtitle: 'إدارة الخدمات التي تقدمها',
                onTap: () => showMessage(
                  context,
                  'صفحة التخصصات والخدمات قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.location_on_outlined,
                title: 'منطقة الخدمة',
                subtitle: 'مدينة نصر، القاهرة',
                onTap: () => showMessage(
                  context,
                  'تعديل منطقة الخدمة قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.star_outline,
                title: 'التقييمات',
                subtitle: 'تقييمك الحالي 4.8',
                onTap: () => showMessage(
                  context,
                  'صفحة التقييمات قريبًا',
                ),
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
                onTap: () => showMessage(
                  context,
                  'إعدادات الإشعارات قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.lock_outline,
                title: 'الخصوصية والأمان',
                subtitle: 'إدارة كلمة المرور وأمان الحساب',
                onTap: () => showMessage(
                  context,
                  'إعدادات الخصوصية قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.help_outline,
                title: 'المساعدة والدعم',
                subtitle: 'تواصل مع فريق Fixly',
                onTap: () => showMessage(
                  context,
                  'صفحة الدعم قريبًا',
                ),
              ),

              profileItem(
                icon: Icons.info_outline,
                title: 'عن Fixly',
                subtitle: 'معلومات عن التطبيق',
                onTap: () => showMessage(
                  context,
                  'Fixly - خدمات الصيانة المنزلية',
                ),
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
                      return AlertDialog(
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
                              style: text(
                                14,
                                FontWeight.w700,
                                kProfileGrey,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              showMessage(
                                context,
                                'اربط الزر بنظام تسجيل الخروج الفعلي',
                              );
                            },
                            child: Text(
                              'تأكيد',
                              style: text(
                                14,
                                FontWeight.w800,
                                Colors.red,
                              ),
                            ),
                          ),
                        ],
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