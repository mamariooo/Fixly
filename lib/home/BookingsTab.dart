import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'ai_chat_screen.dart';

const Color _iconBg = Color(0xFFDCE9FF);
const Color _emptyIconBg = Color(0xFFF0F3F8);
const Color _greenBg = Color(0xFFDDF3E6);
const Color _greenText = Color(0xFF14733A);

class _Booking {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  const _Booking(this.icon, this.title, this.subtitle, this.status);
}

/// تاب "Bookings" (بيتحط جوه الـ Bottom Nav في HomeScreen)
class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  // بيانات تجريبية: استبدلها بالداتا الحقيقية
  // سيب الـ active فاضية عشان تظهر حالة "No active booking yet"
  static const List<_Booking> _active = [];

  static const List<_Booking> _past = [
    _Booking(Icons.water_drop_outlined, 'Kitchen sink leak',
        'Plumbing · 28 Sep · 280 EGP', 'Completed'),
    _Booking(Icons.bolt, 'Ceiling fan install',
        'Electrical · 12 Sep · 220 EGP', 'Completed'),
  ];

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: kGrey,
          ),
        ),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder.withOpacity(0.7)),
      );

  Widget _emptyActiveCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _emptyIconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.web_asset_outlined, color: kGrey, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'No active booking yet',
            style: GoogleFonts.manrope(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Describe a problem and Fixly will find help.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiChatScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Find a Technician',
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

  Widget _bookingCard(_Booking b) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(b.icon, color: kBlue, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.title,
                  style: GoogleFonts.manrope(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  b.subtitle,
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _greenBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              b.status,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _greenText,
              ),
            ),
          ),
        ],
      ),
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
            'Bookings',
            style: GoogleFonts.manrope(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 16),

          _sectionLabel('ACTIVE'),
          if (_active.isEmpty)
            _emptyActiveCard(context)
          else
            ..._active.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _bookingCard(b),
                )),
          const SizedBox(height: 28),

          _sectionLabel('PAST'),
          ..._past.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _bookingCard(b),
              )),
        ],
      ),
    );
  }
}