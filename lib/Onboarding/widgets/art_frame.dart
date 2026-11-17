import 'package:flutter/material.dart';

/// Soft white card with subtle border and shadow, used inside illustrations.
BoxDecoration cardDeco({
  Color color = Colors.white,
  double r = 16,
  Color? borderColor,
}) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(r),
  border: borderColor == null ? null : Border.all(color: borderColor, width: 1),
  boxShadow: const [
    BoxShadow(color: Color(0x140B1F3A), blurRadius: 18, offset: Offset(0, 8)),
  ],
);

/// Rounded tinted container that holds each page's illustration.
class ArtFrame extends StatelessWidget {
  final Color color;
  final Widget child;
  final double minHeight;

  const ArtFrame({
    super.key,
    required this.color,
    required this.child,
    this.minHeight = 240,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
