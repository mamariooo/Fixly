import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixly/admin/admin_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/database/user_repository.dart';
import '../core/models/app_user.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/validators.dart';
import '../home/Dashboard_Technician/technician_home_screen.dart';
import '../home/home.dart';
import 'SignUpScreen.dart';

// ====== Colors ======
const Color kNavy = Color(0xFF0B1F3A);
const Color kBlue = Color(0xFF1D5FD8);
const Color kBg = Color(0xFFF7F8FC);
const Color kGrey = Color(0xFF6B7587);
const Color kBorder = Color(0xFFDCE0EA);

class FixlyLogo extends StatelessWidget {
  const FixlyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/fixly.jpeg', width: 72, height: 72),
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
  const LoginScreen({super.key, this.expectedRole});

  final UserRole? expectedRole;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final AuthService _authService = AuthService();
  final UserRepository _userRepo = UserRepository();

  String? _emailError;
  String? _passError;
  String? _bannerMessage;
  bool _isLoginLoading = false;
  bool _isGoogleLoading = false;

  Future<void> _showForgotPasswordDialog() async {
    final ctrl = TextEditingController(text: _emailCtrl.text.trim());
    String? dialogError;
    bool sending = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            'Reset Password',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the email address associated with your account to receive a password reset link.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  height: 1.45,
                  color: kGrey,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.manrope(fontSize: 15, color: kNavy),
                onChanged: (_) {
                  if (dialogError != null) {
                    setLocal(() => dialogError = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: GoogleFonts.manrope(color: kGrey),
                  prefixIcon: const Icon(
                    Icons.mail_outline,
                    color: kNavy,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: kBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: kBlue, width: 1.5),
                  ),
                  errorText: dialogError,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: C.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: C.error, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: sending ? null : () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: kGrey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: sending
                  ? null
                  : () async {
                      final email = ctrl.text.trim();
                      final err = Validators.email(email);
                      if (err != null) {
                        setLocal(() => dialogError = err);
                        return;
                      }
                      setLocal(() {
                        dialogError = null;
                        sending = true;
                      });
                      try {
                        await _authService.sendPasswordReset(email);
                        if (!ctx.mounted || !mounted) return;
                        Navigator.pop(ctx);
                        setState(() {
                          _bannerMessage =
                              'A password reset link has been sent to your email.';
                        });
                      } on FirebaseAuthException catch (e) {
                        if (!ctx.mounted) return;
                        setLocal(() {
                          sending = false;
                          dialogError =
                              e.message ?? 'Unable to send reset link.';
                        });
                      } catch (_) {
                        if (!ctx.mounted) return;
                        setLocal(() {
                          sending = false;
                          dialogError = 'Unable to send reset link.';
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Send Link',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _routeAfterAuth(AuthResult result) async {
    AppUser? appUser = result.appUser;

    if (appUser == null) {
      await _userRepo.createUserDoc(
        firebaseUser: result.firebaseUser,
        fullName: result.firebaseUser.displayName ?? 'Fixly User',
        phone: result.firebaseUser.phoneNumber,
        role: widget.expectedRole ?? UserRole.client,
        isProfileComplete: true,
      );
      appUser = await _userRepo.getUserById(result.firebaseUser.uid);
      if (!mounted) return;
    }

    if (appUser == null) {
      await _authService.signOut();
      if (!mounted) return;
      setState(() {
        _bannerMessage = 'تعذر تحميل بيانات الحساب.';
      });
      return;
    }

    // 1. توجيه الأدمن لصفحة الأدمن
    if (appUser.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
      return;
    }

    // 2. لو الفني لسه مستني موافقة الأدمن
    if (appUser.isPendingTechnician) {
      if (appUser.isClient) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'حساب الفني قيد مراجعة الأدمن، تم الدخول كعميل مؤقتاً.',
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }
      await _authService.signOut();
      if (!mounted) return;
      setState(() {
        _bannerMessage = 'طلب انضمامك كفني ما زال قيد مراجعة وموافقة الأدمن.';
      });
      return;
    }

    // 3. لو فني وتمت الموافقة عليه
    if (appUser.canOperateAsTechnician &&
        appUser.activeRole == UserRole.technician) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TechnicianHomeScreen()),
      );
      return;
    }

    // 4. المستخدم العميل يدخل على طول
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _onLogin() async {
    final emailError = Validators.emailOrPhone(_emailCtrl.text);
    final passError = Validators.password(_passCtrl.text);

    setState(() {
      _emailError = emailError;
      _passError = passError;
      _bannerMessage = null;
    });

    if (emailError != null || passError != null) return;
    if (_isLoginLoading || _isGoogleLoading) return;

    setState(() => _isLoginLoading = true);

    try {
      final result = await _authService.signInWithEmailOrPhone(
        identifier: _emailCtrl.text,
        password: _passCtrl.text,
      );
      if (!mounted) return;
      await _routeAfterAuth(result);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _bannerMessage = e.message ?? 'تعذر تسجيل الدخول (${e.code})';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _bannerMessage = 'تعذر تسجيل الدخول: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoginLoading = false);
    }
  }

  Future<void> _onGoogleLogin() async {
    if (_isGoogleLoading || _isLoginLoading) return;
    setState(() {
      _isGoogleLoading = true;
      _bannerMessage = null;
    });

    try {
      final result = await _authService.signInWithGoogle();
      if (!mounted) return;
      if (result != null) {
        await _routeAfterAuth(result);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _bannerMessage = e.message ?? 'تعذر تسجيل الدخول بجوجل (${e.code})';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _bannerMessage = 'تعذر تسجيل الدخول بجوجل: $e';
      });
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint, IconData icon, {String? errorText}) {
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
      errorText: errorText,
      errorStyle: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: C.error,
      ),
      errorBorder: border(C.error),
      focusedErrorBorder: border(C.error, 1.5),
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
    final isBusy = _isLoginLoading || _isGoogleLoading;

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
                    if (_bannerMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kBorder),
                        ),
                        child: Text(
                          _bannerMessage!,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kNavy,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    _label('Email or phone'),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
                      onChanged: (_) {
                        if (_emailError != null || _bannerMessage != null) {
                          setState(() {
                            _emailError = null;
                            _bannerMessage = null;
                          });
                        }
                      },
                      decoration: _decoration(
                        'Email or phone',
                        Icons.mail_outline,
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _label('Password'),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
                      onChanged: (_) {
                        if (_passError != null || _bannerMessage != null) {
                          setState(() {
                            _passError = null;
                            _bannerMessage = null;
                          });
                        }
                      },
                      decoration: _decoration(
                        'Password',
                        Icons.lock_outline,
                        errorText: _passError,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isBusy ? null : _showForgotPasswordDialog,
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
                        onPressed: isBusy ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoginLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Expanded(child: Divider(color: kBorder)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              color: kGrey,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: kBorder)),
                      ],
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: isBusy ? null : _onGoogleLogin,
                        icon: _isGoogleLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.g_mobiledata,
                                color: kNavy,
                                size: 32,
                              ),
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

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New to Fixly? ',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: kGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: isBusy
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ),
                                      );
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
