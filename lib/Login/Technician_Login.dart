import 'package:fixly/Login/Signup_Technician.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'package:fixly/core/theme/app_colors.dart';
import 'package:fixly/core/utils/validators.dart';
import 'package:fixly/core/utils/forgot_password.dart';
import 'package:fixly/core/services/technician_application_store.dart';

import 'package:fixly/home/Dashboard_Technician/home_Technicaian.dart'
    hide kGrey, kBorder, kBlue, kNavy, kBg;

const Color kCyan = Color(0xFF14B8D6);
const Color kHeaderSubtitle = Color(0xFF9DB0D3);

class TechnicianLoginScreen extends StatefulWidget {
  const TechnicianLoginScreen({super.key});

  @override
  State<TechnicianLoginScreen> createState() => _TechnicianLoginScreenState();
}

class _TechnicianLoginScreenState extends State<TechnicianLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _emailError;
  String? _passError;

  void _onLogin() {
    final emailError = Validators.emailOrPhone(_emailCtrl.text);
    final passError = Validators.password(_passCtrl.text);

    // لو في طلب انضمام بنفس الرقم ومش متوافق عليه، ممنوع الدخول
    String? gateError;
    final id = _emailCtrl.text.trim();
    if (emailError == null && !id.contains('@')) {
      final app = TechnicianApplicationStore.instance.findByPhone(id);
      if (app != null && app.status != ApplicationStatus.approved) {
        gateError = app.status == ApplicationStatus.pending
            ? 'Your application is still under review'
            : 'Your application was not approved';
      }
    }

    setState(() {
      _emailError = emailError ?? gateError;
      _passError = passError;
    });

    if (emailError != null || passError != null || gateError != null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TechnicianHomeScreen()),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: c, width: w),
  );

  InputDecoration _decoration(String hint, {String? errorText}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(color: kGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      enabledBorder: _border(kBorder),
      focusedBorder: _border(kBlue, 1.5),
      errorText: errorText,
      errorStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: C.error,
      ),
      errorBorder: _border(C.error),
      focusedErrorBorder: _border(C.error, 1.5),
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

  /// الهيدر الغامق: لوجو + PRO + العنوان
  /// استبدل الـ Container الأبيض باللوجو بتاعك لو عاوز
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.hardware, color: kNavy, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'Fixly',
                  style: GoogleFonts.manrope(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kCyan,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PRO',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Fixly Technician',
              style: GoogleFonts.manrope(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Log in to receive jobs near you.',
              style: GoogleFonts.manrope(fontSize: 17, color: kHeaderSubtitle),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),

                          _label('Email or phone'),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: _inputStyle,
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                            decoration: _decoration(
                              'Email or phone',
                              errorText: _emailError,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _label('Password'),
                          TextField(
                            controller: _passCtrl,
                            obscureText: true,
                            style: _inputStyle,
                            onChanged: (_) {
                              if (_passError != null) {
                                setState(() => _passError = null);
                              }
                            },
                            decoration: _decoration(
                              'Password',
                              errorText: _passError,
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  showForgotPasswordDialog(context),
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kNavy,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TechnicianApplyScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'New technician? Apply to join',
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: kBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
