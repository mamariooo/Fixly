import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Onboarding/onboarding_screen.dart';
import '../core/database/user_repository.dart';
import '../core/models/app_user.dart';
import '../core/theme/app_colors.dart';
import '../home/Dashboard_Technician/technician_home_screen.dart';
import '../home/home.dart';
import 'welcome_to_fixly.dart';

class FixlyApp extends StatelessWidget {
  const FixlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

/// Splash that restores session correctly and shows Onboarding only once.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Minimum splash time for branding
    final minDelay = Future.delayed(const Duration(milliseconds: 1800));

    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_completed') ?? false;

      final user = FirebaseAuth.instance.currentUser;

      await minDelay;
      if (!mounted) return;

      if (user != null) {
        // Valid Firebase session → load profile and route by role/status
        final repo = UserRepository();
        AppUser? appUser;
        try {
          appUser = await repo
              .getUserById(user.uid)
              .timeout(const Duration(seconds: 6), onTimeout: () => null);
        } catch (_) {
          appUser = null;
        }

        if (!mounted) return;

        if (appUser == null) {
          // Profile missing → force role selection / welcome
          _go(const WelcometoFixly());
          return;
        }

        // Pending technician must stay in client mode until approved
        final canUseTechnician =
            appUser.isTechnician &&
            appUser.accountStatus == AccountStatus.active;

        if (canUseTechnician && appUser.activeRole == UserRole.technician) {
          _go(const TechnicianHomeScreen());
        } else {
          // Default / client home
          _go(const HomeScreen());
        }
        return;
      }

      // No session
      if (!onboardingDone) {
        _go(const OnboardingScreen());
      } else {
        _go(const WelcometoFixly());
      }
    } catch (e) {
      debugPrint('Splash bootstrap error: $e');
      await minDelay;
      if (!mounted) return;
      _go(const WelcometoFixly());
    }
  }

  void _go(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, a, _, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.navy,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/fixly.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.hardware_rounded,
                        size: 44,
                        color: C.navy,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: C.cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Fixly',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Smart Help. Right Technician. Right Now.',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: const Color(0xFF9FB0C8),
                  ),
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _c,
                builder: (_, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 120,
                    height: 4,
                    child: LinearProgressIndicator(
                      value: _c.value,
                      backgroundColor: const Color(0xFF22395A),
                      valueColor: const AlwaysStoppedAnimation(C.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
