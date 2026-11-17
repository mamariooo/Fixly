import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/Login.dart';
import '../core/theme/app_colors.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onGoogleSignIn});

  /// Callback اختياري لربط Google Sign-In من الخارج
  final Future<void> Function()? onGoogleSignIn;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _index = 0;
  bool _googleLoading = false;

  bool get _isLast => _index == onboardingPages.length - 1;

  Future<void> _goToLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    try {
      if (widget.onGoogleSignIn != null) {
        await widget.onGoogleSignIn!();
      } else {
        // fallback افتراضي يفتح صفحة الدخول لو مفيش callback ممرر
        _goToLogin();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  void _next() {
    if (_isLast) {
      _goToLogin();
      return;
    }
    _ctrl.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpTo(int page) {
    _ctrl.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              _TopBar(
                current: _index,
                total: onboardingPages.length,
                showSkip: !_isLast,
                onSkip: _goToLogin,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: onboardingPages.length,
                  onPageChanged: (v) => setState(() => _index = v),
                  itemBuilder: (_, k) =>
                      _OnboardingPage(data: onboardingPages[k]),
                ),
              ),
              const SizedBox(height: 8),
              _Dots(
                count: onboardingPages.length,
                current: _index,
                onSelect: _jumpTo,
              ),
              const SizedBox(height: 16),
              _PrimaryButton(
                label: _isLast ? 'Get Started' : 'Next',
                icon: _isLast ? Icons.arrow_forward_rounded : null,
                onTap: _next,
              ),
              const SizedBox(height: 10),
              _GoogleButton(loading: _googleLoading, onTap: _handleGoogle),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _GoogleButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: C.navy,
          side: BorderSide(color: C.navy.withValues(alpha: 0.15), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.g_mobiledata_rounded,
                    size: 28,
                    color: C.blue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Continue with Google',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: C.navy,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int current;
  final int total;
  final bool showSkip;
  final VoidCallback onSkip;

  const _TopBar({
    required this.current,
    required this.total,
    required this.showSkip,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.navy.withValues(alpha: .07)),
            ),
            child: Text(
              '${current + 1} / $total',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: C.navy,
              ),
            ),
          ),
          const Spacer(),
          AnimatedOpacity(
            opacity: showSkip ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: TextButton(
              onPressed: showSkip ? onSkip : null,
              style: TextButton.styleFrom(
                foregroundColor: C.grey,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                'Skip',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
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
        const SizedBox(height: 18),
        Text(
          data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: C.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.body,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(fontSize: 14, height: 1.5, color: C.grey),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  final ValueChanged<int> onSelect;

  const _Dots({
    required this.count,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (k) {
        final active = k == current;
        return GestureDetector(
          onTap: () => onSelect(k),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              width: active ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? C.navy : const Color(0xFFD5DCE8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, this.icon, required this.onTap});

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
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
