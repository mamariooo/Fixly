import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import 'admin_theme.dart';

// ───────────────────────── Cards & text blocks ─────────────────────────

class AdminCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;

  const AdminCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.borderColor = A.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0B1F3A),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Card heading: bold title + small grey caption pushed to the end.
class CardTitle extends StatelessWidget {
  final String title;
  final String? caption;

  const CardTitle(this.title, {super.key, this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: aText(16, weight: FontWeight.w800)),
          ),
          if (caption != null)
            Text(caption!, style: aText(12, color: A.grey)),
        ],
      ),
    );
  }
}

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  final String? note;
  final bool dark;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.note,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      color: dark ? A.navy : Colors.white,
      borderColor: dark ? A.navy : A.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: aText(13, color: dark ? A.sub : A.grey)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: aText(
                28,
                weight: FontWeight.w800,
                color: dark ? Colors.white : A.navy,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Text(
              delta!,
              style: aText(
                12,
                weight: FontWeight.w800,
                color: dark ? A.greenBright : A.greenText,
              ),
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 4),
            Text(note!, style: aText(12, weight: FontWeight.w600, color: A.grey)),
          ],
        ],
      ),
    );
  }
}

enum BadgeTone { green, amber, red }

class AdminBadge extends StatelessWidget {
  final String text;
  final BadgeTone tone;
  final double height;
  final double fontSize;

  const AdminBadge(
    this.text, {
    super.key,
    required this.tone,
    this.height = 22,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    switch (tone) {
      case BadgeTone.green:
        bg = A.greenTint;
        fg = A.greenText;
      case BadgeTone.amber:
        bg = A.amberTint;
        fg = A.amberText;
      case BadgeTone.red:
        bg = A.redTint;
        fg = A.redText;
    }
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height > 24 ? 14 : 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: aText(fontSize, color: fg)),
    );
  }
}

/// Horizontal progress row: label · bar · value.
class HBarRow extends StatelessWidget {
  final String label;
  final double labelWidth;
  final double fraction; // 0..1
  final String value;
  final double valueWidth;
  final Color color;

  const HBarRow({
    super.key,
    required this.label,
    required this.labelWidth,
    required this.fraction,
    required this.value,
    this.valueWidth = 48,
    this.color = A.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: aText(13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  Container(height: 10, color: A.track),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: fraction.clamp(0.0, 1.0),
                      child: Container(height: 10, color: color),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: valueWidth,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: aText(13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical bar chart (revenue / confidence distribution).
class BarColumn {
  final String label;
  final double height;
  final Color color;
  final bool emphasized;

  const BarColumn(this.label, this.height, this.color,
      {this.emphasized = false});
}

class BarColumns extends StatelessWidget {
  final List<BarColumn> bars;
  final double height;
  final double radius;

  const BarColumns({
    super.key,
    required this.bars,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < bars.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: bars[i].height,
                      decoration: BoxDecoration(
                        color: bars[i].color,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(radius),
                          bottom: const Radius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bars[i].label,
                      maxLines: 1,
                      style: aText(
                        11,
                        color: bars[i].emphasized ? A.navy : A.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String text;
  final bool line;

  const LegendDot(this.color, this.text, {super.key, this.line = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: line ? 14 : 10,
          height: line ? 3 : 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(line ? 0 : 3),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: aText(line ? 12 : 13)),
      ],
    );
  }
}

/// Table-like row. Pass [flexes] for column proportions.
class TableRowX extends StatelessWidget {
  final List<Widget> cells;
  final List<int> flexes;
  final bool header;

  const TableRowX({
    super.key,
    required this.cells,
    required this.flexes,
    this.header = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, header ? 0 : 10, 0, 10),
      decoration: BoxDecoration(
        border: header
            ? null
            : const Border(top: BorderSide(color: A.track)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              flex: flexes[i],
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: cells[i],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget thText(String s) => Text(
      isAr ? s : s.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: aText(11,
          weight: FontWeight.w800, color: A.grey, letterSpacing: isAr ? 0 : 0.8),
    );

Widget tdText(String s) => Text(
      s,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: aText(13),
    );

// ───────────────────────── Responsive "auto-fit" grid ─────────────────────────

/// Equivalent of CSS `grid-template-columns: repeat(auto-fit, minmax(min, 1fr))`.
class AutoFitGrid extends StatelessWidget {
  final double minItemWidth;
  final double gap;
  final List<Widget> children;

  const AutoFitGrid({
    super.key,
    required this.minItemWidth,
    required this.children,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cols = math.max(1, ((width + gap) / (minItemWidth + gap)).floor());
        final itemWidth = (width - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final c in children) SizedBox(width: itemWidth, child: c),
          ],
        );
      },
    );
  }
}

// ───────────────────────── Charts (CustomPaint) ─────────────────────────

class LineSeries {
  /// Points in the original viewBox (400 × 150) coordinates.
  final List<Offset> points;
  final Color color;
  final bool dashed;
  final bool fill;

  const LineSeries(this.points, this.color, {this.dashed = false, this.fill = false});
}

class LineChartPainter extends CustomPainter {
  final List<LineSeries> series;
  final List<double> gridY;
  final double fillBaseY;

  static const double vbW = 400;
  static const double vbH = 150;

  LineChartPainter({
    required this.series,
    required this.gridY,
    this.fillBaseY = 150,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / vbW;
    final sy = size.height / vbH;
    Offset p(Offset o) => Offset(o.dx * sx, o.dy * sy);

    final gridPaint = Paint()
      ..color = A.track
      ..strokeWidth = 1;
    for (final y in gridY) {
      canvas.drawLine(Offset(0, y * sy), Offset(size.width, y * sy), gridPaint);
    }

    for (final s in series) {
      final path = Path()..moveTo(p(s.points.first).dx, p(s.points.first).dy);
      for (final o in s.points.skip(1)) {
        path.lineTo(p(o).dx, p(o).dy);
      }

      if (s.fill) {
        final area = Path.from(path)
          ..lineTo(p(Offset(s.points.last.dx, fillBaseY)).dx, fillBaseY * sy)
          ..lineTo(p(Offset(s.points.first.dx, fillBaseY)).dx, fillBaseY * sy)
          ..close();
        canvas.drawPath(
          area,
          Paint()..color = s.color.withValues(alpha: 0.08),
        );
      }

      final stroke = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (s.dashed) {
        canvas.drawPath(_dash(path, 6, 5), stroke);
      } else {
        canvas.drawPath(path, stroke);
      }
    }
  }

  Path _dash(Path source, double dash, double gap) {
    final out = Path();
    for (final PathMetric m in source.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        out.addPath(m.extractPath(d, math.min(d + dash, m.length)), Offset.zero);
        d += dash + gap;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(covariant LineChartPainter old) => true;
}

class LineChart extends StatelessWidget {
  final List<LineSeries> series;
  final List<double> gridY;
  final double height;

  const LineChart({
    super.key,
    required this.series,
    required this.gridY,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: LineChartPainter(series: series, gridY: gridY),
      ),
    );
  }
}

class _Seg {
  final double fraction;
  final Color color;
  const _Seg(this.fraction, this.color);
}

class _RingPainter extends CustomPainter {
  final List<_Seg> segs;
  final double stroke;
  final bool roundCap;

  _RingPainter(this.segs, this.stroke, this.roundCap);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width * 0.4;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);

    canvas.drawCircle(
      rect.center,
      r,
      Paint()
        ..color = A.track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    double start = -math.pi / 2;
    for (final s in segs) {
      final sweep = 2 * math.pi * s.fraction;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = roundCap ? StrokeCap.round : StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => true;
}

/// Single-value progress ring with a centred label (AI Monitoring KPIs).
class RingGauge extends StatelessWidget {
  final double fraction;
  final Color color;
  final String label;

  const RingGauge({
    super.key,
    required this.fraction,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(84, 84),
            painter: _RingPainter([_Seg(fraction, color)], 9, true),
          ),
          Text(label, style: aText(18, weight: FontWeight.w800)),
        ],
      ),
    );
  }
}

/// Multi-segment donut (customer satisfaction).
class DonutChart extends StatelessWidget {
  final List<MapEntry<double, Color>> segments;
  final Widget center;
  final double size;

  const DonutChart({
    super.key,
    required this.segments,
    required this.center,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              [for (final s in segments) _Seg(s.key, s.value)],
              16,
              false,
            ),
          ),
          center,
        ],
      ),
    );
  }
}
