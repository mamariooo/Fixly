import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';
import 'package:fixly/core/theme/app_colors.dart';
import 'onboarding_data.dart';

/// 3-page intro shown after "Continue as customer".
/// "Skip" and "Get Started" both lead to the customer [LoginScreen].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _index = 0;

  bool get _isLast => _index == onboardingPages.length - 1;

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) {
          return const LoginScreen();
        },
        transitionsBuilder: (_, a, _, child) => FadeTransition(
          opacity: a,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .04), end: Offset.zero)
                .animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      ),
    );
  }

  void _next() {
    if (_isLast) return _goToLogin();
    _ctrl.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              _SkipButton(visible: !_isLast, onTap: _goToLogin),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: onboardingPages.length,
                  onPageChanged: (v) => setState(() => _index = v),
                  itemBuilder: (_, k) => _OnboardingPage(data: onboardingPages[k]),
                ),
              ),
              _Dots(count: onboardingPages.length, current: _index),
              const SizedBox(height: 24),
              _PrimaryButton(
                label: _isLast ? 'Get Started' : 'Next',
                onTap: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: data.art()),
        const SizedBox(height: 24),
        Text(
          data.title,
          style: GoogleFonts.manrope(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: C.navy,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.body,
          style: GoogleFonts.manrope(fontSize: 14, height: 1.5, color: C.grey),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;
  const _SkipButton({required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Align(
        alignment: Alignment.centerRight,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: TextButton(
            onPressed: visible ? onTap : null,
            child: Text(
              'Skip',
              style: GoogleFonts.manrope(
                color: C.grey,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  const _Dots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (k) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: k == current ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: k == current ? C.navy : const Color(0xFFD5DCE8),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: C.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}
