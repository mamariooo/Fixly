import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

const Color _iconBg = Color(0xFFDCE9FF);
const Color _dropFill = Color(0xFFF0F5FD);
const Color _dropBorder = Color(0xFFA9BAD3);
const Color _stepInactiveBg = Color(0xFFE6EAF2);
const Color _stepLine = Color(0xFFE1E5EE);

class AiImageAnalysisScreen extends StatefulWidget {
  const AiImageAnalysisScreen({super.key});

  @override
  State<AiImageAnalysisScreen> createState() => _AiImageAnalysisScreenState();
}

class _AiImageAnalysisScreenState extends State<AiImageAnalysisScreen> {
  // 0 = Upload, 1 = Analyzing, 2 = Result
  int _step = 0;

  Future<void> _choosePhoto() async {
    // TODO: اختار صورة (مثلاً بـ image_picker)، وبعدها:
    // setState(() => _step = 1);   // Analyzing
    // ... ابعت الصورة للـ AI، ولما يرجع النتيجة:
    // setState(() => _step = 2);   // Result
  }

  // ---------- Header ----------
  Widget _header() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder.withOpacity(0.6)),
            ),
            child: const Icon(Icons.chevron_left, color: kNavy, size: 28),
          ),
        ),
        const SizedBox(width: 18),
        Text(
          'AI Image Analysis',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
      ],
    );
  }

  // ---------- Stepper ----------
  Widget _stepItem(int index, String label) {
    final active = index <= _step;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? kNavy : _stepInactiveBg,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : kGrey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            color: active ? kNavy : kGrey,
          ),
        ),
      ],
    );
  }

  Widget _stepLineWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(height: 2, color: _stepLine),
      ),
    );
  }

  Widget _stepper() {
    return Row(
      children: [
        _stepItem(0, 'Upload'),
        _stepLineWidget(),
        _stepItem(1, 'Analyzing'),
        _stepLineWidget(),
        _stepItem(2, 'Result'),
      ],
    );
  }

  // ---------- Upload box ----------
  Widget _uploadBox() {
    return GestureDetector(
      onTap: _choosePhoto,
      child: CustomPaint(
        painter: _DashedBoxPainter(
          fill: _dropFill,
          border: _dropBorder,
          radius: 30,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(32),
                ),
                child:
                    const Icon(Icons.photo_camera, color: kBlue, size: 44),
              ),
              const SizedBox(height: 22),
              Text(
                'Upload a photo of the problem',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Clear, well-lit photos give better results.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 18),
              _stepper(),
              const SizedBox(height: 18),

              // TODO: لما تعمل شاشات Analyzing و Result، بدّل المحتوى حسب _step
              Expanded(child: _uploadBox()),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _choosePhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Choose photo',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// صندوق بخلفية وبوردر متقطع (dashed) من غير أي باكدج
class _DashedBoxPainter extends CustomPainter {
  final Color fill;
  final Color border;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedBoxPainter({
    required this.fill,
    required this.border,
    this.radius = 30,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    canvas.drawRRect(rrect, Paint()..color = fill);

    final stroke = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final path = Path()..addRRect(rrect.deflate(1));

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          stroke,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBoxPainter old) =>
      old.fill != fill || old.border != border || old.radius != radius;
}