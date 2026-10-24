import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:fixly/Login/Login.dart';
import 'package:fixly/core/services/booking_store.dart';
=======

import 'package:fixly/Login/Login.dart';
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

TextStyle _text(double size, FontWeight weight, Color color) {
  return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
}

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

<<<<<<< HEAD
=======
  static const List<List<String>> jobs = [
    ['التكييف مش بيبرّد', 'سارة م. · النهاردة', '480'],
    ['غسالة', 'منى أ. · امبارح', '320'],
    ['تركيب تكييف سبليت', 'عمرو ك. · ٨ أكتوبر', '260'],
  ];

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
  Widget jobCard(String title, String subtitle, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          // الأيقونة (على اليمين)
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.hardware, color: kBlue, size: 26),
          ),
          const SizedBox(width: 14),

          // العنوان والتفاصيل
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _text(19, FontWeight.w800, kNavy)),
              Text(subtitle, style: _text(14, FontWeight.w500, kGrey)),
            ],
          ),
          const Spacer(),

          // السعر والحالة (على الشمال)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$price ج.م', style: _text(17, FontWeight.w800, kNavy)),
              const SizedBox(height: 6),
              Container(
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
=======
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF3E6),
                  borderRadius: BorderRadius.circular(20),
                ),
<<<<<<< HEAD
                child: Text(
                  'مكتملة',
                  style: _text(13, FontWeight.w800, const Color(0xFF14733A)),
                ),
=======
                child: Text('مكتملة',
                    style: _text(13, FontWeight.w800, const Color(0xFF14733A))),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              ),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
static const List<String> _months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]}';

=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
<<<<<<< HEAD
        child: ListenableBuilder(
          listenable: BookingStore.instance,
          builder: (context, _) {
            final jobs = BookingStore.instance.completedJobs.reversed.toList();

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('سجل الشغل', style: _text(30, FontWeight.w800, kNavy)),
                const SizedBox(height: 16),
                if (jobs.isEmpty)
                  Text(
                    'مفيش شغل مكتمل لسه.',
                    style: _text(15, FontWeight.w500, kGrey),
                  )
                else
                  for (final b in jobs)
                    jobCard(
                      b.issue,
                      '${b.service} · ${_date(b.createdAt)}',
                      '${b.price ?? 0}',
                    ),
              ],
            );
          },
=======
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('سجل الشغل', style: _text(30, FontWeight.w800, kNavy)),
            const SizedBox(height: 16),
            for (final job in jobs) jobCard(job[0], job[1], job[2]),
          ],
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        ),
      ),
    );
  }
<<<<<<< HEAD
}

=======
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
