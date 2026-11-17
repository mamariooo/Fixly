import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../simple_chat_screen.dart';
import 'page_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<(String, String)> _faqs = [
    (
      'How do I request a technician?',
      'Describe your problem in the AI chat, then tap "Request a technician" under the summary card.',
    ),
    (
      'How can I cancel a booking?',
      'Open Bookings, tap the booking, then "Cancel booking". You can cancel before the technician starts working.',
    ),
    (
      'How do I rate a technician?',
      'When the job is completed, open the booking from the Bookings tab and tap "Rate technician".',
    ),
    (
      'How is the price decided?',
      'The technician enters the final price when the job is finished.',
    ),
    (
      'How do I pay?',
      'For now you pay the technician directly. Online payment is coming soon.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Help & Support',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Frequently asked questions',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 12),
          for (final f in _faqs)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder.withValues(alpha: 0.7)),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    f.$1,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.$2,
                      style: GoogleFonts.manrope(fontSize: 15, color: kGrey),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SimpleChatScreen(
                      title: 'Fixly Support',
                      initialMessages: ['Hi! How can we help you today?'],
                      replies: [
                        'Thanks for the details. We are checking this now.',
                        'Is there anything else we can help you with?',
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.support_agent),
              label: Text(
                'Chat with support',
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
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
  }
}

// =====================================================
// Saved Locations
// =====================================================
