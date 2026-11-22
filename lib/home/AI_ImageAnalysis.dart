import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/services/fixly_ai_service.dart';
import '../core/theme/app_colors.dart';
import '../main.dart';
import 'ai_chat_screen.dart';

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
  String? _imagePath;
  AiDiagnosisResult? _result;

  Future<void> _choosePhoto() async {
    final isAr = appLocale.value.languageCode == 'ar';
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(isAr ? 'التقاط صورة بالكاميرا' : 'Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(isAr ? 'اختيار صورة من المعرض' : 'Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final file = await _picker.pickImage(source: source, imageQuality: 80);
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _imagePath = file.path;
        _step = 1; // Analyzing
      });

      // تحليل بالذكاء الاصطناعي الحقيقي
      final diagnosis = await FixlyAiService.instance.diagnoseProblem(
        description: file.name,
        imageBytes: bytes,
      );

      if (!mounted) return;

      setState(() {
        _result = diagnosis;
        _step = 2; // Result
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _step = 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تعذر فتح الكاميرا أو المعرض' : 'Could not open the camera/gallery',
          ),
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _step = 0;
      _imageBytes = null;
      _imagePath = null;
      _result = null;
    });
  }

  void _continueWithResult() {
    final r = _result;
    if (r == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AiChatScreen(
          initialPhotoBytes: _imageBytes,
          initialPhotoPath: _imagePath,
          initialMessage:
              'تحليل الصورة أظهر عطل في (${r.serviceCategory}): ${r.issueSummary} (الأهمية: ${r.urgency}).',
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _header() {
    final isAr = appLocale.value.languageCode == 'ar';
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder.withValues(alpha: 0.6)),
            ),
            child: const Icon(Icons.arrow_back, color: kNavy, size: 24),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          isAr ? 'تحليل الصور بالذكاء الاصطناعي' : 'AI Image Analysis',
          style: GoogleFonts.manrope(
            fontSize: 20,
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
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? kNavy : _stepInactiveBg,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : kGrey,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(height: 2, color: _stepLine),
      ),
    );
  }

  Widget _stepper() {
    final isAr = appLocale.value.languageCode == 'ar';
    return Row(
      children: [
        _stepItem(0, isAr ? 'رفع الصورة' : 'Upload'),
        _stepLineWidget(),
        _stepItem(1, isAr ? 'جاري التحليل' : 'Analyzing'),
        _stepLineWidget(),
        _stepItem(2, isAr ? 'النتيجة' : 'Result'),
      ],
    );
  }

  // ---------- Upload box ----------
  Widget _uploadBox() {
    final isAr = appLocale.value.languageCode == 'ar';
    return GestureDetector(
      onTap: _choosePhoto,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: _dropFill,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _dropBorder, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.photo_camera, color: kBlue, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              isAr ? 'ارفع صورة واضحة للعطل أو المشكلة' : 'Upload a photo of the problem',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isAr
                  ? 'الصور الواضحة والمضاءة جيداً تساعد الذكاء الاصطناعي في تحديد العطل بدقة وترشيح الفني الأنسب'
                  : 'Clear, well-lit photos give better AI diagnosis and matching.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Analyzing ----------
  Widget _analyzingView() {
    final isAr = appLocale.value.languageCode == 'ar';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                _imageBytes!,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: kBlue),
          const SizedBox(height: 18),
          Text(
            isAr ? 'يقوم Fixly AI بتحليل الصورة وتشخيص العطل...' : 'Fixly AI is analyzing your photo...',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 18,
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: kGrey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultView() {
    final isAr = appLocale.value.languageCode == 'ar';
    final r = _result!;
    final percent = (r.confidence * 100).round();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(
                _imageBytes!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _resultRow(isAr ? 'الخدمة' : 'SERVICE', r.serviceCategory),
                _resultRow(isAr ? 'العطل المشخص' : 'POSSIBLE ISSUE', r.issueSummary),
                _resultRow(
                  isAr ? 'مستوى الخبرة المطلوبة' : 'DIFFICULTY LEVEL',
                  r.needsExpert
                      ? (isAr ? 'يحتاج خبير معتمد ★' : 'Requires Certified Expert ★')
                      : (isAr ? 'صيانة عامة' : 'Standard Repair'),
                ),
                _resultRow(isAr ? 'الأهمية' : 'URGENCY', r.urgency),
                Text(
                  '${isAr ? 'دقة التشخيص' : 'AI CONFIDENCE'}  $percent%',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: kGrey,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: r.confidence,
                    minHeight: 7,
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
    final isAr = appLocale.value.languageCode == 'ar';
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              _stepper(),
              const SizedBox(height: 16),
              Expanded(child: _body()),
              const SizedBox(height: 16),
              if (_step != 1)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _step == 0 ? _choosePhoto : _continueWithResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _step == 0
                          ? (isAr ? 'اختيار صورة' : 'Choose photo')
                          : (isAr
                              ? 'المتابعة لترشيح الفني والطلب'
                              : 'Continue to AI Chat & Technician Match'),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
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
                      isAr ? 'تحليل صورة أخرى' : 'Analyze another photo',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
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
