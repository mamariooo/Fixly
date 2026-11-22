import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'art_frame.dart';

/// Page 2 illustration: AI match card + matched technician card.
class AiArt extends StatelessWidget {
  const AiArt({super.key});

  @override
  Widget build(BuildContext context) {
    return ArtFrame(
      color: C.tealTint,
      child: LayoutBuilder(
        builder: (_, box) {
          final s =
              (box.maxWidth < box.maxHeight ? box.maxWidth : box.maxHeight)
                  .clamp(210.0, 340.0);

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: s * 0.94,
                height: s * 0.94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: C.cyan.withValues(alpha: .32)),
                ),
              ),

              // AI match card
              Positioned(
                top: box.maxHeight * 0.18,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: C.navy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: C.cyan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'FIXLY AI · 94% MATCH',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              letterSpacing: .8,
                              fontWeight: FontWeight.w800,
                              color: C.cyan,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'AC not cooling → AC Specialist',
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: .94,
                          minHeight: 5,
                          backgroundColor: Color(0xFF22395A),
                          valueColor: AlwaysStoppedAnimation(C.cyan),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Technician card
              Positioned(
                bottom: box.maxHeight * 0.14,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: cardDeco(
                    r: 18,
                    borderColor: C.navy.withValues(alpha: .05),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: C.blueTint,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'AH',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: C.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Hassan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: C.navy,
                              ),
                            ),
                            Text(
                              '4.8 ★ · 1.2 km · 8 min',
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: C.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: C.greenTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Verified',
                          style: GoogleFonts.manrope(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: C.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
