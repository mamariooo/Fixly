import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';

class TechnicianApplyScreen extends StatefulWidget {
  const TechnicianApplyScreen({super.key});

  @override
  State<TechnicianApplyScreen> createState() => _TechnicianApplyScreenState();
}

class _TechnicianApplyScreenState extends State<TechnicianApplyScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final List<String> _skills = const [
    'AC Specialist',
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Appliance Repair',
  ];
  String? _selectedSkill;

  // اسم الملف اللي المستخدم اختاره (بعد ما تربط image_picker)
  String? _idPhotoName;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _yearsCtrl.dispose();
    _areaCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  InputDecoration _decoration({String? hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(color: kGrey),
      prefixIcon: prefix,
      prefixIconConstraints: prefix == null
          ? null
          : const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      enabledBorder: _border(kBorder),
      focusedBorder: _border(kBlue, 1.5),
    );
  }

  TextStyle get _inputStyle =>
      GoogleFonts.manrope(fontSize: 17, color: kNavy);

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: kNavy,
          ),
        ),
      );

  Widget _phoneField() {
    return TextField(
      controller: _phoneCtrl,
      keyboardType: TextInputType.phone,
      style: _inputStyle,
      decoration: _decoration(
        hint: '101 234 5678',
        prefix: Padding(
          padding: const EdgeInsets.only(left: 20, right: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+20',
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 28, color: kBorder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skillDropdown() {
    return InputDecorator(
      decoration: _decoration().copyWith(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSkill,
          isExpanded: true,
          hint: Text(
            'Select your main skill',
            style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: kNavy),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          style: _inputStyle,
          items: _skills
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedSkill = v),
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: () {
        // TODO: pick image (مثلاً بـ image_picker) وخزّن اسم الملف في _idPhotoName
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(color: kBorder, radius: 16),
        child: Container(
          width: double.infinity,
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.file_upload_outlined,
                  color: _idPhotoName == null ? kGrey : kNavy, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _idPhotoName ?? 'Upload photo',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    color: _idPhotoName == null ? kGrey : kNavy,
                  ),
                ),
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
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header: back + title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              border:
                                  Border.all(color: kBorder.withOpacity(0.6)),
                            ),
                            child: const Icon(Icons.chevron_left,
                                color: kNavy, size: 28),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Join as technician',
                              style: GoogleFonts.manrope(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: kNavy,
                              ),
                            ),
                            Text(
                              'We review every application.',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: kGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _label('Full name'),
                    TextField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      style: _inputStyle,
                      decoration: _decoration(hint: 'Full name'),
                    ),
                    const SizedBox(height: 20),

                    _label('Phone'),
                    _phoneField(),
                    const SizedBox(height: 20),

                    _label('Main skill'),
                    _skillDropdown(),
                    const SizedBox(height: 20),

                    // Years + Area
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Years of experience'),
                              TextField(
                                controller: _yearsCtrl,
                                keyboardType: TextInputType.number,
                                style: _inputStyle,
                                decoration: _decoration(hint: '0'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Area'),
                              TextField(
                                controller: _areaCtrl,
                                style: _inputStyle,
                                decoration: _decoration(hint: 'Area'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _label('National ID photo'),
                    _uploadBox(),
                    const SizedBox(height: 20),

                    _label('Password'),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: _inputStyle,
                      decoration: _decoration(hint: 'At least 8 characters'),
                    ),

                    const Spacer(),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: submit application
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Submit application',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// بوردر متقطع (dashed) من غير أي باكدج
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    this.radius = 16,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}