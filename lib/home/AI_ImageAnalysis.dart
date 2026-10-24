import 'dart:ui' show PathMetric;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  _Analysis? _result;

  Future<void> _choosePhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final file = await _picker.pickImage(source: source, imageQuality: 80);
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _step = 1; // Analyzing
      });

      // تحليل وهمي (بدل الـ AI الحقيقي)
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(() {
        _result = _mockAnalysis(file.name);
        _step = 2; // Result
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _step = 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the camera/gallery')),
      );
    }
  }

  _Analysis _mockAnalysis(String fileName) {
    const results = [
      _Analysis(
        'Air Conditioning',
        'Dirty filter / low cooling',
        'Medium',
        0.86,
      ),
      _Analysis('Plumbing', 'Pipe leak under the sink', 'High', 0.81),
      _Analysis('Electrical', 'Damaged socket or wiring', 'High', 0.78),
      _Analysis(
        'Appliance Repair',
        'Washing machine drainage issue',
        'Low',
        0.74,
      ),
    ];
    final sum = fileName.codeUnits.fold<int>(0, (a, b) => a + b);
    return results[sum % results.length];
  }

  void _reset() {
    setState(() {
      _step = 0;
      _imageBytes = null;
      _result = null;
    });
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
              border: Border.all(color: kBorder.withValues(alpha: 0.6)),
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
                child: const Icon(Icons.photo_camera, color: kBlue, size: 44),
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

  // ---------- Analyzing ----------
  Widget _analyzingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.memory(
                _imageBytes!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 28),
          const CircularProgressIndicator(color: kBlue),
          const SizedBox(height: 20),
          Text(
            'Analyzing your photo...',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Result ----------
  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: kGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultView() {
    final r = _result!;
    final percent = (r.confidence * 100).round();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.memory(
                _imageBytes!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _resultRow('SERVICE', r.service),
                _resultRow('POSSIBLE ISSUE', r.issue),
                _resultRow('URGENCY', r.urgency),
                Text(
                  'AI CONFIDENCE  $percent%',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kGrey,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: r.confidence,
                    minHeight: 8,
                    color: kBlue,
                    backgroundColor: _stepInactiveBg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_step) {
      case 1:
        return _analyzingView();
      case 2:
        return _resultView();
      default:
        return _uploadBox();
    }
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
              Expanded(child: _body()),
              const SizedBox(height: 20),
              if (_step != 1)
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _step == 0
                        ? _choosePhoto
                        : () => Navigator.maybePop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      _step == 0 ? 'Choose photo' : 'Done',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (_step == 2)
                Center(
                  child: TextButton(
                    onPressed: _reset,
                    child: Text(
                      'Analyze another photo',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kBlue,
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

class _DashedBoxPainter extends CustomPainter {
  final Color fill;
  final Color border;
  final double radius;
  static const double dashWidth = 6;
  static const double dashGap = 4;

  _DashedBoxPainter({
    required this.fill,
    required this.border,
    this.radius = 30,
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

class _Analysis {
  final String service;
  final String issue;
  final String urgency;
  final double confidence;

  const _Analysis(this.service, this.issue, this.urgency, this.confidence);
}
