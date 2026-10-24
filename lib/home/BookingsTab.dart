import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
<<<<<<< HEAD
import 'package:fixly/core/models/booking.dart';
import 'package:fixly/core/services/booking_store.dart';
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
import 'ai_chat_screen.dart';

const Color _iconBg = Color(0xFFDCE9FF);
const Color _emptyIconBg = Color(0xFFF0F3F8);
const Color _greenBg = Color(0xFFDDF3E6);
const Color _greenText = Color(0xFF14733A);
<<<<<<< HEAD
const Color _amberBg = Color(0xFFFDEBC8);
const Color _amberText = Color(0xFF8A5300);
const Color _blueBg = Color(0xFFDCE9FF);
const Color _blueText = Color(0xFF1B4FA8);
const Color _redBg = Color(0xFFFDE2E1);
const Color _redText = Color(0xFFB42318);
=======

class _Booking {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  const _Booking(this.icon, this.title, this.subtitle, this.status);
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

/// تاب "Bookings" (بيتحط جوه الـ Bottom Nav في HomeScreen)
class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

<<<<<<< HEAD
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<(BookingStatus, String)> _steps = [
    (BookingStatus.pending, 'Request sent'),
    (BookingStatus.accepted, 'Technician accepted'),
    (BookingStatus.onTheWay, 'On the way'),
    (BookingStatus.inProgress, 'Work in progress'),
    (BookingStatus.completed, 'Completed'),
  ];

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  (Color, Color) _statusColors(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
        return (_amberBg, _amberText);
      case BookingStatus.accepted:
      case BookingStatus.onTheWay:
      case BookingStatus.inProgress:
        return (_blueBg, _blueText);
      case BookingStatus.completed:
        return (_greenBg, _greenText);
      case BookingStatus.cancelled:
        return (_redBg, _redText);
    }
  }

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
    border: Border.all(color: kBorder.withValues(alpha: 0.7)),
  );
=======
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
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

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

<<<<<<< HEAD
  Widget _bookingCard(BuildContext context, Booking b) {
    final (bg, fg) = _statusColors(b.status);
    final priceText = b.price == null ? '' : ' · ${b.price} EGP';

    return InkWell(
      onTap: () => _openDetails(context, b),
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                    b.issue,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${b.service} · ${_date(b.createdAt)}$priceText',
                    style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                b.status.label,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- تفاصيل الحجز + التتبع ----------
  void _openDetails(BuildContext context, Booking b) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => ListenableBuilder(
        listenable: BookingStore.instance,
        builder: (_, _) => _detailsSheet(sheetContext, b),
      ),
    );
  }

  Widget _stepRow(String label, {required bool done, required bool current}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? kBlue : kBorder,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: current ? FontWeight.w800 : FontWeight.w600,
              color: done ? kNavy : kGrey,
=======
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
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _detailsSheet(BuildContext context, Booking b) {
    final cancelled = b.status == BookingStatus.cancelled;
    final canCancel =
        b.status == BookingStatus.pending || b.status == BookingStatus.accepted;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              b.issue,
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${b.service} · ${b.urgency} urgency',
              style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
            ),
            if (b.technicianName != null) ...[
              const SizedBox(height: 10),
              Text(
                'Technician: ${b.technicianName}',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                ),
              ),
            ],
            if (b.price != null) ...[
              const SizedBox(height: 4),
              Text(
                'Price: ${b.price} EGP',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                ),
              ),
            ],
            if (b.address != null) ...[
              const SizedBox(height: 4),
              Text(
                'Address: ${b.address}',
                style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
              ),
            ],
            if (b.paymentMethod != null) ...[
              const SizedBox(height: 4),
              Text(
                'Payment: ${b.paymentMethod}',
                style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
              ),
            ],
            const SizedBox(height: 18),
            if (cancelled)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _redBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'This booking was cancelled',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _redText,
                  ),
                ),
              )
            else
              ..._steps.map(
                (s) => _stepRow(
                  s.$2,
                  done: b.status.index >= s.$1.index,
                  current: b.status == s.$1,
                ),
              ),
            const SizedBox(height: 18),
            if (canCancel)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => BookingStore.instance.cancel(b),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _redText,
                    side: const BorderSide(color: _redText),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Cancel booking',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            if (b.status == BookingStatus.completed && b.rating == null)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _rate(context, b),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Rate technician',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            if (b.status == BookingStatus.completed && b.rating != null)
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      i < b.rating! ? Icons.star : Icons.star_border,
                      color: const Color(0xFFF5B301),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Thanks for rating!',
                    style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _rate(BuildContext context, Booking b) async {
    int stars = 5;
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate your technician'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => IconButton(
                onPressed: () => setLocal(() => stars = i + 1),
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(),
                icon: Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF5B301),
                  size: 34,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, stars),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    if (result != null) BookingStore.instance.rate(b, result);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: BookingStore.instance,
      builder: (context, _) {
        final active = BookingStore.instance.active;
        final past = BookingStore.instance.past;

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
              if (active.isEmpty)
                _emptyActiveCard(context)
              else
                ...active.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _bookingCard(context, b),
                  ),
                ),
              const SizedBox(height: 28),

              _sectionLabel('PAST'),
              if (past.isEmpty)
                Text(
                  'No past bookings yet.',
                  style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                )
              else
                ...past.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _bookingCard(context, b),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
=======
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
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
