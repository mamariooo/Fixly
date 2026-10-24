import 'package:flutter/material.dart';

import 'package:fixly/core/theme/app_colors.dart';
import 'art_frame.dart';

/// Page 1 illustration: house icon surrounded by service chips.
class HomeArt extends StatelessWidget {
  const HomeArt({super.key});

  Widget _chip(IconData icon) => Container(
        width: 44,
        height: 44,
        decoration: cardDeco(r: 14),
        child: Icon(icon, size: 20, color: C.blue),
      );

  @override
  Widget build(BuildContext context) {
    return ArtFrame(
      color: C.blueTint,
      child: LayoutBuilder(builder: (_, box) {
        final w = box.maxWidth, h = box.maxHeight;
        final s = w < h ? w : h;
        return Stack(alignment: Alignment.center, children: [
          for (final d in [s * 0.88, s * 0.62])
            Container(
              width: d,
              height: d,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: C.ring.withValues(alpha: .7)),
              ),
            ),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: C.navy,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.home_outlined,
                size: 52, color: Colors.white),
          ),
          Positioned(left: w * 0.08, top: h * 0.12, child: _chip(Icons.bolt)),
          Positioned(
              right: w * 0.14,
              top: h * 0.2,
              child: _chip(Icons.water_drop_outlined)),
          Positioned(
              left: w * 0.2, bottom: h * 0.16, child: _chip(Icons.ac_unit)),
          Positioned(
              right: w * 0.1,
              bottom: h * 0.12,
              child: _chip(Icons.build_outlined)),
        ]);
      }),
    );
  }
}
