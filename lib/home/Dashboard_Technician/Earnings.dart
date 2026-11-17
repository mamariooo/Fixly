import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/database/firestore_paths.dart';
import '../../core/models/booking.dart';
import '../../core/services/booking_store.dart';

const Color kEarningsNavy = Color(0xFF1C3358);
const Color kEarningsBg = Color(0xFFF5F7FB);
const Color kEarningsGrey = Color(0xFF8492A6);
const Color kEarningsBorder = Color(0xFFE5EAF1);
const Color kEarningsGreen = Color(0xFF1F9D63);

class TechnicianEarningsScreen extends StatelessWidget {
  const TechnicianEarningsScreen({super.key});

  TextStyle text(double size, FontWeight weight, Color color) {
    return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
  }

  int _totalFromBookings(List<Booking> jobs) {
    return jobs.fold<int>(0, (acc, b) => acc + (b.price ?? 0));
  }

  Widget _transactionTile(Booking b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            child: Icon(b.icon, color: kEarningsGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.issue, style: text(15, FontWeight.w800, kEarningsNavy)),
                Text(
                  'طلب مكتمل',
                  style: text(12, FontWeight.w500, kEarningsGrey),
                ),
              ],
            ),
          ),
          Text(
            '+${b.price ?? 0} ج.م',
            style: text(15, FontWeight.w800, kEarningsGreen),
          ),
        ],
      ),
    );
  }

  Widget _transactions(List<Booking> jobs) {
    final done = jobs.reversed.toList();

    if (done.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kEarningsBorder),
        ),
        child: Text(
          'مفيش معاملات لسه.',
          style: text(14, FontWeight.w500, kEarningsGrey),
        ),
      );
    }

    return Column(children: [for (final b in done) _transactionTile(b)]);
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
            Text(title, style: text(12, FontWeight.w500, kEarningsGrey)),
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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userStream = uid == null
        ? null
        : FirebaseFirestore.instance
              .collection(FirestorePaths.users)
              .doc(uid)
              .snapshots();

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
          child: ListenableBuilder(
            listenable: BookingStore.instance,
            builder: (context, _) {
              final completed = BookingStore.instance.completedJobs;
              final computedTotal = _totalFromBookings(completed);

              return StreamBuilder(
                stream: userStream,
                builder: (context, snap) {
                  final rawData = snap.data?.data();
                  final userData = rawData is Map<String, dynamic>
                      ? rawData
                      : const <String, dynamic>{};

                  final storedEarnings = (userData['totalEarnings'] as num?)
                      ?.toInt();
                  final pendingPayout =
                      (userData['pendingPayout'] as num?)?.toInt() ?? 0;
                  final totalEarnings = storedEarnings ?? computedTotal;

                  return SingleChildScrollView(
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
                                    style: text(
                                      16,
                                      FontWeight.w600,
                                      Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                '$totalEarnings ج.م',
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
                                  style: text(
                                    12,
                                    FontWeight.w600,
                                    Colors.white,
                                  ),
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
                              value: '${completed.length}',
                            ),
                            const SizedBox(width: 12),
                            summaryCard(
                              icon: Icons.pending_actions_outlined,
                              title: 'قيد التحويل',
                              value: '$pendingPayout ج.م',
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
                          ],
                        ),

                        const SizedBox(height: 8),

                        _transactions(completed),

                        const SizedBox(height: 24),

                        // زر سحب الأرباح
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (uid != null && totalEarnings > 0) {
                                await FirebaseFirestore.instance
                                    .collection(FirestorePaths.users)
                                    .doc(uid)
                                    .set({
                                      'pendingPayout': totalEarnings,
                                      'lastPayoutRequestedAt':
                                          FieldValue.serverTimestamp(),
                                    }, SetOptions(merge: true));
                              }
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'تم تسجيل طلب سحب الأرباح للمراجعة',
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
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
