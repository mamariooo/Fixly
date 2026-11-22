import 'dart:ui' show PathMetric;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../core/database/firestore_paths.dart';
import '../core/database/user_repository.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/validators.dart';
import 'Technician_Login.dart';

class TechnicianApplyScreen extends StatefulWidget {
  const TechnicianApplyScreen({super.key});

  @override
  State<TechnicianApplyScreen> createState() => _TechnicianApplyScreenState();
}

class _TechnicianApplyScreenState extends State<TechnicianApplyScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final AuthService _authService = AuthService();

  final List<String> _skills = const [
    // نفس أسماء تخصصات الـ AI والفلاتر عشان الترشيح يطابق
    'Air Conditioning',
    'Electrical',
    'Plumbing',
    'Carpentry',
    'Painting',
    'Appliances',
  ];
  String? _selectedSkill;

  String? _idPhotoName;
  final ImagePicker _picker = ImagePicker();

  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _skillError;
  String? _yearsError;
  String? _areaError;
  String? _idError;
  String? _passError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _yearsCtrl.dispose();
    _areaCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: c, width: w),
  );

  InputDecoration _decoration({
    String? hint,
    Widget? prefix,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      errorStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: C.error,
      ),
      errorBorder: _border(C.error),
      focusedErrorBorder: _border(C.error, 1.5),
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

  TextStyle get _inputStyle => GoogleFonts.manrope(fontSize: 17, color: kNavy);

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
      onChanged: (_) {
        if (_phoneError != null) setState(() => _phoneError = null);
      },
      decoration: _decoration(
        hint: '101 234 5678',
        errorText: _phoneError,
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
      decoration: _decoration(errorText: _skillError).copyWith(
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
          onChanged: (v) => setState(() {
            _selectedSkill = v;
            _skillError = null;
          }),
        ),
      ),
    );
  }

  Future<void> _pickIdPhoto() async {
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
      setState(() {
        _idPhotoName = file.name;
        _idError = null;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the camera/gallery')),
      );
    }
  }

  Future<void> _submit() async {
    final nameError = Validators.fullName(_nameCtrl.text);
    final phoneError = Validators.phone(_phoneCtrl.text);
    final emailError = Validators.email(_emailCtrl.text);
    final skillError = _selectedSkill == null ? 'Select your main skill' : null;
    final yearsError = Validators.years(_yearsCtrl.text);
    final areaError = Validators.required(_areaCtrl.text, 'Required');
    final idError = _idPhotoName == null
        ? 'National ID photo is required'
        : null;
    final passError = Validators.password(_passCtrl.text);
    if (await UserRepository().isPhoneTaken(_phoneCtrl.text.trim())) {
      if (!mounted) return;
      setState(() => _phoneError = 'This phone number is already registered');
      return;
    }
    setState(() {
      _nameError = nameError;
      _phoneError = phoneError;
      _emailError = emailError;
      _skillError = skillError;
      _yearsError = yearsError;
      _areaError = areaError;
      _idError = idError;
      _passError = passError;
    });

    if ([
      nameError,
      phoneError,
      emailError,
      skillError,
      yearsError,
      areaError,
      idError,
      passError,
    ].any((e) => e != null)) {
      return;
    }

    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final skill = _selectedSkill!;
    final years = _yearsCtrl.text.trim();
    final area = _areaCtrl.text.trim();
    final idPhoto = _idPhotoName!;

    try {
      final authResult = await _authService.signUpTechnician(
        fullName: name,
        phone: phone,
        email: email,
        password: _passCtrl.text,
        area: area,
        specialty: skill,
      );

      await FirebaseFirestore.instance
          .collection(FirestorePaths.technicianApplications)
          .doc(authResult.firebaseUser.uid)
          .set({
            'uid': authResult.firebaseUser.uid,
            'fullName': name,
            'phone': phone,
            'email': email,
            'skill': skill,
            'years': years,
            'area': area,
            'idPhotoName': idPhoto,
            'role': 'technician',
            'status': 'pending_approval',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      await _authService.signOut();

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Application received'),
          content: const Text(
            'Thanks! We review every application. '
            'You can sign in once it is approved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TechnicianLoginScreen()),
        (route) => route.isFirst,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'تعذر إرسال الطلب (${e.code})')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر إرسال الطلب: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: _pickIdPhoto,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: _idError != null ? C.error : kBorder,
          radius: 16,
        ),
        child: Container(
          width: double.infinity,
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                Icons.file_upload_outlined,
                color: _idPhotoName == null ? kGrey : kNavy,
                size: 26,
              ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
                        border: Border.all(
                          color: kBorder.withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: kNavy,
                        size: 28,
                      ),
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
                        style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
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
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
                decoration: _decoration(
                  hint: 'Full name',
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 20),
              _label('Phone'),
              _phoneField(),
              const SizedBox(height: 20),
              _label('Email'),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: _inputStyle,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
                decoration: _decoration(hint: 'Email', errorText: _emailError),
              ),
              const SizedBox(height: 20),
              _label('Main skill'),
              _skillDropdown(),
              const SizedBox(height: 20),
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
                          onChanged: (_) {
                            if (_yearsError != null) {
                              setState(() => _yearsError = null);
                            }
                          },
                          decoration: _decoration(
                            hint: '0',
                            errorText: _yearsError,
                          ),
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
                          onChanged: (_) {
                            if (_areaError != null) {
                              setState(() => _areaError = null);
                            }
                          },
                          decoration: _decoration(
                            hint: 'Area',
                            errorText: _areaError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _label('National ID photo'),
              _uploadBox(),
              if (_idError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    _idError!,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: C.error,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              _label('Password'),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                style: _inputStyle,
                onChanged: (_) {
                  if (_passError != null) setState(() => _passError = null);
                },
                decoration: _decoration(
                  hint: 'At least 8 characters',
                  errorText: _passError,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit application',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  static const double dashWidth = 6;
  static const double dashGap = 4;

  _DashedBorderPainter({required this.color, this.radius = 16});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

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
