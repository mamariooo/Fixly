import 'package:fixly/Login/SignUpScreen.dart';
<<<<<<< HEAD
import 'package:fixly/core/theme/app_colors.dart';
import 'package:fixly/core/utils/validators.dart';
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
import 'package:fixly/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ====== Colors ======
const Color kNavy = Color(0xFF0B1F3A);
const Color kBlue = Color(0xFF1D5FD8);
const Color kBg = Color(0xFFF7F8FC);
const Color kGrey = Color(0xFF6B7587);
const Color kBorder = Color(0xFFDCE0EA);

/// استبدل الويدجت دي باللوجو بتاعك (أو import للملف اللي فيه اللوجو)
/// لو عندك صورة: Image.asset('assets/logo.png', width: 72, height: 72)
class FixlyLogo extends StatelessWidget {
  const FixlyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       
        Image.asset(
          'assets/images/fixly.jpeg',
          width: 72,
          height: 72,
        ),
        const SizedBox(width: 16),
        Text(
          'Fixly',
          style: GoogleFonts.manrope(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: kNavy,
          ),
        ),
      ],
    );
  }
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

<<<<<<< HEAD
  String? _emailError;
  String? _passError;

  void _onLogin() {
    final emailError = Validators.emailOrPhone(_emailCtrl.text);
    final passError = Validators.password(_passCtrl.text);

    setState(() {
      _emailError = emailError;
      _passError = passError;
    });

    if (emailError != null || passError != null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  InputDecoration _decoration(String hint, IconData icon, {String? errorText}) {
=======
  InputDecoration _decoration(String hint, IconData icon) {
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(color: kGrey),
      prefixIcon: Icon(icon, color: kNavy, size: 22),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 22),
      enabledBorder: border(kBorder),
      focusedBorder: border(kBlue, 1.5),
<<<<<<< HEAD
      errorText: errorText,
      errorStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: C.error,
      ),
      errorBorder: border(C.error),
      focusedErrorBorder: border(C.error, 1.5),
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    );
  }

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
                    const SizedBox(height: 24),
                    const FixlyLogo(),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome back',
                      style: GoogleFonts.manrope(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to find a technician in minutes.',
                      style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
                    ),
                    const SizedBox(height: 28),

                    // Email
                    _label('Email or phone'),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
<<<<<<< HEAD
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                      decoration: _decoration(
                        'Email or phone',
                        Icons.mail_outline,
                        errorText: _emailError,
                      ),
=======
                      decoration:
                          _decoration('Email or phone', Icons.mail_outline),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _label('Password'),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
<<<<<<< HEAD
                      onChanged: (_) {
                        if (_passError != null) {
                          setState(() => _passError = null);
                        }
                      },
                      decoration: _decoration(
                        'Password',
                        Icons.lock_outline,
                        errorText: _passError,
                      ),
=======
                      decoration: _decoration('Password', Icons.lock_outline),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                    ),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          //forgot
                        },
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

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
<<<<<<< HEAD
                        onPressed: _onLogin,
=======
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        },
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
                    const SizedBox(height: 22),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: kBorder)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.manrope(
                                fontSize: 15, color: kGrey),
                          ),
                        ),
                        const Expanded(child: Divider(color: kBorder)),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          //Continue with Google
                        },
                        icon: const Icon(Icons.g_mobiledata,
                            color: kNavy, size: 32),
                        label: Text(
                          'Continue with Google',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kNavy,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: kBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Create account
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New to Fixly? ',
                              style: GoogleFonts.manrope(
                                  fontSize: 16, color: kGrey),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                                // navigate to sign up
                              },
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: kBlue,
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
      ),
    );
  }
}