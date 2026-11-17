import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/booking.dart';
import '../../core/services/booking_store.dart';
import '../../core/theme/app_colors.dart';
import 'page_scaffold.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

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

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  Widget _historyCard(Booking b) {
    final done = b.status == BookingStatus.completed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(b.icon, color: kBlue, size: 24),
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
                  '${b.service} · ${_date(b.createdAt)}',
                  style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                ),
                if (b.technicianName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Technician: ${b.technicianName}',
                    style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                  ),
                ],
                if (b.rating != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < b.rating! ? Icons.star : Icons.star_border,
                        color: const Color(0xFFF5B301),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (b.price != null) ...[
                Text(
                  '${b.price} EGP',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFFDDF3E6)
                      : const Color(0xFFFDE2E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  b.status.label,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: done
                        ? const Color(0xFF14733A)
                        : const Color(0xFFB42318),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Service History',
      child: ListenableBuilder(
        listenable: BookingStore.instance,
        builder: (context, _) {
          final items = BookingStore.instance.past;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 48, color: kGrey),
                    const SizedBox(height: 12),
                    Text(
                      'No past services yet',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Completed and cancelled bookings will show up here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _historyCard(items[i]),
          );
        },
      ),
    );
  }
}

// =====================================================
// Help & Support
// =====================================================
