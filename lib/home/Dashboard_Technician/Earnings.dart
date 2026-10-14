
import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';

const Color kEarningsNavy = Color(0xFF1C3358);
const Color kEarningsBg = Color(0xFFF5F7FB);
const Color kEarningsGrey = Color(0xFF8492A6);
const Color kEarningsBorder = Color(0xFFE5EAF1);
const Color kEarningsGreen = Color(0xFF1F9D63);

class TechnicianEarningsScreen extends StatelessWidget {
  const TechnicianEarningsScreen({super.key});

  TextStyle text(double size, FontWeight weight, Color color) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  Widget summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kEarningsBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: kEarningsGreen, size: 25),
            const SizedBox(height: 12),
            Text(
              title,
              style: text(12, FontWeight.w500, kEarningsGrey),
            ),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: text(19, FontWeight.w800, kEarningsNavy),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kEarningsBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'الأرباح',
            style: text(22, FontWeight.w800, kEarningsNavy),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة أرباحك',
                  style: text(25, FontWeight.w800, kEarningsNavy),
                ),
                const SizedBox(height: 5),
                Text(
                  'تابع دخلك وطلبات السحب الخاصة بك',
                  style: text(14, FontWeight.w500, kEarningsGrey),
                ),
                const SizedBox(height: 22),

                // إجمالي الأرباح
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kEarningsNavy,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white70,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'إجمالي أرباحك',
                            style: text(16, FontWeight.w600, Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '850 ج.م',
                        style: text(36, FontWeight.w800, Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'أرباحك المسجلة',
                          style: text(12, FontWeight.w600, Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // الإحصائيات
                Row(
                  children: [
                    summaryCard(
                      icon: Icons.check_circle_outline,
                      title: 'طلبات مكتملة',
                      value: '5',
                    ),
                    const SizedBox(width: 12),
                    summaryCard(
                      icon: Icons.pending_actions_outlined,
                      title: 'قيد التحويل',
                      value: '0 ج.م',
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'آخر المعاملات',
                      style: text(21, FontWeight.w800, kEarningsNavy),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'عرض الكل',
                        style: text(13, FontWeight.w700, kEarningsGreen),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // معاملة تجريبية
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kEarningsBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F7EA),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.build_outlined,
                          color: kEarningsGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'صيانة تكييف',
                              style: text(15, FontWeight.w800, kEarningsNavy),
                            ),
                            Text(
                              'طلب مكتمل',
                              style: text(12, FontWeight.w500, kEarningsGrey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+300 ج.م',
                        style: text(15, FontWeight.w800, kEarningsGreen),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // زر سحب الأرباح
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'سيتم تفعيل سحب الأرباح بعد ربط نظام الدفع',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.account_balance),
                    label: Text(
                      'سحب الأرباح',
                      style: text(17, FontWeight.w800, Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kEarningsGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
}
