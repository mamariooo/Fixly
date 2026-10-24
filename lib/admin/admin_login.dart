import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fixly/main.dart' show appLocale;
import 'package:fixly/core/utils/validators.dart';
import 'admin_home.dart';
import 'admin_theme.dart';
<<<<<<< HEAD
import 'package:fixly/core/config/admin_config.dart';
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

/// Admin sign in: work email + password + 6-digit two-step code.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _codeFocus = FocusNode();

  bool _hidePass = true;
  String? _emailError;
  String? _passError;
  String? _codeError;

  @override
  void initState() {
    super.initState();
    _codeCtrl.addListener(() => setState(() {}));
    _codeFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _codeCtrl.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _onSignIn() {
<<<<<<< HEAD
    var emailError = Validators.email(_emailCtrl.text);
    if (emailError == null && !isAdminEmail(_emailCtrl.text)) {
      emailError = tr(
        'This email is not authorized',
        'هذا البريد غير مصرّح له',
      );
    }
=======
    final emailError = Validators.email(_emailCtrl.text);
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    final passError = Validators.password(_passCtrl.text);
    final codeError = _codeCtrl.text.length == 6
        ? null
        : tr('Enter the 6-digit code', 'أدخل الرمز المكوّن من 6 أرقام');

    setState(() {
      _emailError = emailError;
      _passError = passError;
      _codeError = codeError;
    });

    if (emailError != null || passError != null || codeError != null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminHome()),
    );
  }

  // ───────── pieces ─────────

  Widget _logoRow() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.build_rounded, color: A.navy, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Fixly',
<<<<<<< HEAD
          style: aText(
            26,
            weight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
=======
          style: aText(26,
              weight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        ),
        const SizedBox(width: 10),
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: A.cyan,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text('ADMIN', style: aText(12, weight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _brandPanel({required bool compact}) {
    return Container(
      color: A.navy,
      padding: compact
          ? EdgeInsets.fromLTRB(
<<<<<<< HEAD
              24,
              20 + MediaQuery.of(context).padding.top,
              24,
              32,
            )
          : const EdgeInsets.all(64),
      child: Column(
        mainAxisAlignment: compact
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
=======
              24, 20 + MediaQuery.of(context).padding.top, 24, 32)
          : const EdgeInsets.all(64),
      child: Column(
        mainAxisAlignment:
            compact ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          _logoRow(),
          if (compact) const SizedBox(height: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('Operations console', 'لوحة العمليات'),
                style: aText(
                  compact ? 30 : 44,
                  weight: FontWeight.w800,
                  color: Colors.white,
                  height: compact ? 1.2 : 1.18,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Text(
                  tr(
                    'Monitor requests, technicians, revenue and AI accuracy in one place.',
                    'تابع الطلبات والفنيين والإيرادات ودقة الذكاء الاصطناعي في مكان واحد.',
                  ),
                  style: aText(
                    compact ? 15 : 17,
                    weight: FontWeight.w500,
                    color: A.sub,
                    height: 1.65,
                  ),
                ),
              ),
            ],
          ),
          if (!compact)
            Text(
              tr(
                'Authorized Fixly staff only. All sign-ins are logged.',
                'للعاملين المصرّح لهم في Fixly فقط. يتم تسجيل جميع عمليات الدخول.',
              ),
              style: aText(13, weight: FontWeight.w600, color: A.sub),
            ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
<<<<<<< HEAD
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: aText(13)),
  );

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c, width: w),
  );

  InputDecoration _decoration(
    String hint, {
    String? errorText,
    Widget? suffix,
  }) {
=======
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: aText(13)),
      );

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );

  InputDecoration _decoration(String hint, {String? errorText, Widget? suffix}) {
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    return InputDecoration(
      hintText: hint,
      hintStyle: aText(15, weight: FontWeight.w500, color: A.grey),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: _border(A.inputBorder),
      focusedBorder: _border(A.blue, 1.5),
      errorText: errorText,
      errorStyle: aText(12, weight: FontWeight.w600, color: A.red),
      errorBorder: _border(A.red),
      focusedErrorBorder: _border(A.red, 1.5),
    );
  }

  Widget _otpBoxes() {
    final text = _codeCtrl.text;
    final focused = _codeFocus.hasFocus;
    final active = text.length.clamp(0, 5);

    return Stack(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              for (var i = 0; i < 6; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.9,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _codeError != null
                              ? A.red
                              : (focused && i == active)
<<<<<<< HEAD
                              ? A.blue
                              : A.inputBorder,
=======
                                  ? A.blue
                                  : A.inputBorder,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                          width: (focused && i == active) ? 1.5 : 1,
                        ),
                        boxShadow: (focused && i == active)
                            ? const [
                                BoxShadow(color: A.blueTint, spreadRadius: 4),
                              ]
                            : null,
                      ),
                      child: Text(
                        i < text.length ? text[i] : '',
                        style: aText(20, weight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Invisible field that captures the typing for all six boxes.
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: _codeCtrl,
              focusNode: _codeFocus,
              keyboardType: TextInputType.number,
              showCursor: false,
              enableInteractiveSelection: false,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: (_) {
                if (_codeError != null) setState(() => _codeError = null);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          tr('Admin sign in', 'تسجيل دخول المشرف'),
          style: aText(28, weight: FontWeight.w800, letterSpacing: -0.4),
        ),
        const SizedBox(height: 8),
        Text(
          tr(
            'Use your company email. Customers and technicians cannot sign in here.',
            'استخدم بريد الشركة. لا يمكن للعملاء والفنيين تسجيل الدخول من هنا.',
          ),
<<<<<<< HEAD
          style: aText(
            15,
            weight: FontWeight.w500,
            color: A.grey,
            height: 1.45,
          ),
=======
          style: aText(15, weight: FontWeight.w500, color: A.grey, height: 1.45),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        ),
        const SizedBox(height: 24),
        _label(tr('Work email', 'بريد العمل')),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: aText(15, weight: FontWeight.w600),
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
          decoration: _decoration('admin@fixly.com', errorText: _emailError),
        ),
        const SizedBox(height: 16),
        _label(tr('Password', 'كلمة المرور')),
        TextField(
          controller: _passCtrl,
          obscureText: _hidePass,
          style: aText(15, weight: FontWeight.w600),
          onChanged: (_) {
            if (_passError != null) setState(() => _passError = null);
          },
          decoration: _decoration(
            '••••••••••',
            errorText: _passError,
            suffix: IconButton(
              onPressed: () => setState(() => _hidePass = !_hidePass),
              icon: Icon(
                _hidePass
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: A.grey,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _label(tr('Two-step verification code', 'رمز التحقق بخطوتين')),
        _otpBoxes(),
        if (_codeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: Text(
              _codeError!,
              style: aText(12, weight: FontWeight.w600, color: A.red),
            ),
          ),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _onSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: A.navy,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              tr('Sign in', 'تسجيل الدخول'),
              style: aText(16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => showAdminToast(
              context,
<<<<<<< HEAD
              tr(
                'Contact IT: it@fixly.com',
                'تواصل مع قسم تقنية المعلومات: it@fixly.com',
              ),
            ),
            child: Text(
              tr(
                'Contact IT if you lost access',
                'تواصل مع الدعم التقني إذا فقدت الوصول',
              ),
=======
              tr('Contact IT: it@fixly.com', 'تواصل مع قسم تقنية المعلومات: it@fixly.com'),
            ),
            child: Text(
              tr('Contact IT if you lost access',
                  'تواصل مع الدعم التقني إذا فقدت الوصول'),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              textAlign: TextAlign.center,
              style: aText(13, color: A.linkBlue),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: A.warnBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tr(
              'Access is granted by invitation. Roles: Super admin, Support, Finance.',
              'يتم منح الوصول بدعوة فقط. الأدوار: مشرف رئيسي، دعم، مالية.',
            ),
<<<<<<< HEAD
            style: aText(
              12,
              weight: FontWeight.w600,
              color: A.warnText,
              height: 1.5,
            ),
=======
            style: aText(12, weight: FontWeight.w600, color: A.warnText, height: 1.5),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
<<<<<<< HEAD
      builder: (context, _, _) {
=======
      builder: (context, _, __) {
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        return Scaffold(
          backgroundColor: A.bg,
          body: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;

              if (wide) {
                return Row(
                  children: [
                    Expanded(child: _brandPanel(compact: false)),
                    SizedBox(
                      width: 560,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(48),
                          child: _form(),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _brandPanel(compact: true),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: _form(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
