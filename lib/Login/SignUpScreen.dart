import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// الألوان (kNavy, kBlue, kBg, kGrey, kBorder) موجودة في login_screen.dart
import 'Login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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
        hint: '100 123 4567',
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
      ).copyWith(
        // عشان الـ prefix ياخد عرضه الطبيعي
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }

  void _onCreateAccount() {
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    // TODO: create account logic
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

                    // Back button
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
                        child: const Icon(Icons.chevron_left,
                            color: kNavy, size: 28),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Create Account',
                      style: GoogleFonts.manrope(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Takes under a minute.',
                      style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
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

                    _label('Email'),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: _inputStyle,
                      decoration: _decoration(hint: 'Email'),
                    ),
                    const SizedBox(height: 20),

                    _label('Password'),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: _inputStyle,
                      decoration: _decoration(hint: 'Password'),
                    ),
                    const SizedBox(height: 20),

                    _label('Confirm password'),
                    TextField(
                      controller: _confirmCtrl,
                      obscureText: true,
                      style: _inputStyle,
                      decoration: _decoration(hint: 'Confirm password'),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'By continuing you agree to the Terms and Privacy Policy.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kGrey,
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _onCreateAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Create Account',
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