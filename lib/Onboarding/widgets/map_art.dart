import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/core/theme/app_colors.dart';
import 'art_frame.dart';

/// Draws the fake street grid + route used on page 3.
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = const Color(0xFFD5DEEC);
    for (final fx in [0.2, 0.7, 0.92]) {
      canvas.drawRect(
          Rect.fromLTWH(size.width * fx - 6, 0, 12, size.height), road);
    }
    for (final fy in [0.2, 0.42, 0.75]) {
      canvas.drawRect(
          Rect.fromLTWH(0, size.height * fy - 6, size.width, 12), road);
    }

    final start = Offset(size.width * 0.2, size.height * 0.75);
    final end = Offset(size.width * 0.92, size.height * 0.2);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(start.dx, size.height * 0.42)
      ..lineTo(size.width * 0.7, size.height * 0.42)
      ..lineTo(size.width * 0.7, end.dy)
      ..lineTo(end.dx, end.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = C.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(start, 7, Paint()..color = C.navy);
    canvas.drawCircle(end, 14, Paint()..color = Colors.white);
    canvas.drawCircle(end, 10, Paint()..color = C.cyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Page 3 illustration: live tracking map with an "On the way" card.
class MapArt extends StatelessWidget {
  const MapArt({super.key});

  @override
  Widget build(BuildContext context) {
    return ArtFrame(
      color: C.blueTint,
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: cardDeco(r: 16),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('On the way',
                        style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: C.navy)),
                    Text('Ahmed arrives in 7 min',
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: C.grey)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: C.blueTint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Live',
                    style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: C.blue)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
