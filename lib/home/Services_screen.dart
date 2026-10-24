import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// الألوان الأساسية (kNavy, kBlue, kBg, kGrey, kBorder) موجودة في login_screen.dart
import 'package:fixly/Login/Login.dart';
import 'ai_chat_screen.dart';

const Color _iconBg = Color(0xFFDCE9FF);

/// تاب "All Services" (بيتحط جوه الـ Bottom Nav في HomeScreen)
class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  static const List<(IconData, String)> _services = [
    (Icons.bolt, 'Electrical'),
    (Icons.water_drop_outlined, 'Plumbing'),
    (Icons.ac_unit, 'AC'),
    (Icons.hardware, 'Carpentry'),
    (Icons.auto_awesome_outlined, 'Cleaning'),
    (Icons.brush_outlined, 'Painting'),
    (Icons.settings_outlined, 'Appliances'),
    (Icons.more_horiz, 'Other'),
  ];

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AiChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Services',
            style: GoogleFonts.manrope(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a service or just describe the problem.',
            style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, i) {
              final item = _services[i];
              return InkWell(
                onTap: () => _openChat(context), // أي سيرفس يفتح شات الـ AI
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kBorder.withValues(alpha: 0.7)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _iconBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(item.$1, color: kBlue, size: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.$2,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => _openChat(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Describe your problem...',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}