// pubspec.yaml -> dependencies:  google_fonts: ^6.2.1
import 'dart:async';
import 'package:fixly/Splash/welcome_to_fixly.dart';
import 'package:fixly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FixlyApp extends StatelessWidget {
  const FixlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}



// ---------- Splash ----------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..forward();
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const WelcometoFixly(),
          transitionsBuilder: (_, a, _, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.navy,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26)),
                padding: const EdgeInsets.all(22),
                child: Image.asset(
                  'assets/images/fixly.jpeg', 
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                      Icons.hardware_rounded,
                      size: 44,
                      color: C.navy),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                      color: C.cyan, shape: BoxShape.circle),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Text('Fixly',
                style: GoogleFonts.manrope(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text('Smart Help. Right Technician. Right Now.',
                style: GoogleFonts.manrope(
                    fontSize: 14, color: const Color(0xFF9FB0C8))),
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
    );
  }
}
