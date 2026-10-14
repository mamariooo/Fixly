import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

TextStyle _text(double size, FontWeight weight, Color color) {
  return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
}

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  static const List<List<String>> jobs = [
    ['التكييف مش بيبرّد', 'سارة م. · النهاردة', '480'],
    ['غسالة', 'منى أ. · امبارح', '320'],
    ['تركيب تكييف سبليت', 'عمرو ك. · ٨ أكتوبر', '260'],
  ];

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF3E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('مكتملة',
                    style: _text(13, FontWeight.w800, const Color(0xFF14733A))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('سجل الشغل', style: _text(30, FontWeight.w800, kNavy)),
            const SizedBox(height: 16),
            for (final job in jobs) jobCard(job[0], job[1], job[2]),
          ],
        ),
      ),
    );
  }
}