import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'art_frame.dart';

/// Page 1 illustration: house icon surrounded by service chips.
class HomeArt extends StatelessWidget {
  const HomeArt({super.key});

  Widget _chip(IconData icon) => Container(
    width: 46,
    height: 46,
    decoration: cardDeco(r: 15, borderColor: C.ring.withValues(alpha: .35)),
    child: Icon(icon, size: 21, color: C.blue),
  );

  @override
  Widget build(BuildContext context) {
    return ArtFrame(
      color: C.blueTint,
      child: LayoutBuilder(
        builder: (_, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;
          final s = (w < h ? w : h).clamp(200.0, 340.0);

          return Stack(
            alignment: Alignment.center,
            children: [
              for (final ratio in [0.88, 0.62])
                Container(
                  width: s * ratio,
                  height: s * ratio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: C.ring.withValues(alpha: .65),
                      width: 1.2,
                    ),
                  ),
                ),
              Container(
                width: 98,
                height: 98,
                decoration: cardDeco(color: C.navy, r: 28),
                child: const Icon(
                  Icons.home_outlined,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: w * 0.09,
                top: h * 0.14,
                child: _chip(Icons.bolt),
              ),
              Positioned(
                right: w * 0.13,
                top: h * 0.18,
                child: _chip(Icons.water_drop_outlined),
              ),
              Positioned(
                left: w * 0.18,
                bottom: h * 0.16,
                child: _chip(Icons.ac_unit),
              ),
              Positioned(
                right: w * 0.11,
                bottom: h * 0.13,
                child: _chip(Icons.build_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}
