import 'package:flutter/material.dart';

/// Soft white card with shadow, used inside the onboarding illustrations.
BoxDecoration cardDeco({Color color = Colors.white, double r = 16}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(r),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A0B1F3A),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ],
    );

/// Rounded tinted container that holds each page's illustration.
class ArtFrame extends StatelessWidget {
  final Color color;
  final Widget child;

  const ArtFrame({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}
