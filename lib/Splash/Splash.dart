// pubspec.yaml -> dependencies:  google_fonts: ^6.2.1
import 'dart:async';
import 'package:fixly/Splash/welcome_to_Fixly.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------- Design tokens ----------
class C {
  static const navy = Color(0xFF0B1F3A);
  static const cyan = Color(0xFF12B5D6);
  static const blue = Color(0xFF2563EB);
  static const bg = Color(0xFFF6F8FC);
  static const blueTint = Color(0xFFE6F0FE);
  static const tealTint = Color(0xFFE0F5FA);
  static const grey = Color(0xFF5B6B80);
  static const ring = Color(0xFFB9CCE8);
  static const green = Color(0xFF1E9E5A);
  static const greenTint = Color(0xFFDDF5E7);
}


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
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, a, __, child) =>
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
                  errorBuilder: (_, __, ___) => const Icon(
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
              builder: (_, __) => ClipRRect(
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

// ---------- Onboarding ----------
class _PageData {
  final String title, body;
  final Widget Function() art;
  const _PageData(this.title, this.body, this.art);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _i = 0;

  late final List<_PageData> _pages = [
    _PageData(
      'Your Home, Our Help',
      'From a flickering light to a leaking pipe, trusted technicians are one message away.',
      () => const _HomeArt(),
    ),
    _PageData(
      'AI Finds the Right Technician',
      'Describe it, snap it, or say it. Fixly ranks technicians by skill, rating and availability, not just distance.',
      () => const _AiArt(),
    ),
    _PageData(
      'Track. Fix. Relax.',
      'Follow your technician live, pay securely, and rate the job when it is done.',
      () => const _MapArt(),
    ),
  ];

  bool get _last => _i == _pages.length - 1;

  void _finish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const  WelcometoFixly(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(
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
    if (_last) return _finish();
    _ctrl.nextPage(
        duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
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
              SizedBox(
                height: 36,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedOpacity(
                    opacity: _last ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: _last ? null : _finish,
                      child: Text('Skip',
                          style: GoogleFonts.manrope(
                              color: C.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _pages.length,
                  onPageChanged: (v) => setState(() => _i = v),
                  itemBuilder: (_, k) {
                    final p = _pages[k];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: p.art()),
                        const SizedBox(height: 24),
                        Text(p.title,
                            style: GoogleFonts.manrope(
                                fontSize: 24,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                                color: C.navy)),
                        const SizedBox(height: 10),
                        Text(p.body,
                            style: GoogleFonts.manrope(
                                fontSize: 14, height: 1.5, color: C.grey)),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (k) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: k == _i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: k == _i ? C.navy : const Color(0xFFD5DCE8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text(_last ? 'Get Started' : 'Next',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Shared bits ----------
BoxDecoration _cardDeco({Color color = Colors.white, double r = 16}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(r),
      boxShadow: const [
        BoxShadow(
            color: Color(0x1A0B1F3A), blurRadius: 16, offset: Offset(0, 6))
      ],
    );

class _ArtFrame extends StatelessWidget {
  final Color color;
  final Widget child;
  const _ArtFrame({required this.color, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(32)),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}

// ---------- Page 1 art ----------
class _HomeArt extends StatelessWidget {
  const _HomeArt();

  Widget _chip(IconData icon) => Container(
        width: 44,
        height: 44,
        decoration: _cardDeco(r: 14),
        child: Icon(icon, size: 20, color: C.blue),
      );

  @override
  Widget build(BuildContext context) {
    return _ArtFrame(
      color: C.blueTint,
      child: LayoutBuilder(builder: (_, box) {
        final w = box.maxWidth, h = box.maxHeight;
        final s = w < h ? w : h;
        return Stack(alignment: Alignment.center, children: [
          for (final d in [s * 0.88, s * 0.62])
            Container(
              width: d,
              height: d,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: C.ring.withOpacity(.7)),
              ),
            ),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
                color: C.navy, borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.home_outlined,
                size: 52, color: Colors.white),
          ),
          Positioned(left: w * 0.08, top: h * 0.12, child: _chip(Icons.bolt)),
          Positioned(
              right: w * 0.14, top: h * 0.2, child: _chip(Icons.water_drop_outlined)),
          Positioned(
              left: w * 0.2, bottom: h * 0.16, child: _chip(Icons.ac_unit)),
          Positioned(
              right: w * 0.1, bottom: h * 0.12, child: _chip(Icons.build_outlined)),
        ]);
      }),
    );
  }
}

// ---------- Page 2 art ----------
class _AiArt extends StatelessWidget {
  const _AiArt();

  @override
  Widget build(BuildContext context) {
    return _ArtFrame(
      color: C.tealTint,
      child: LayoutBuilder(builder: (_, box) {
        final s = box.maxWidth < box.maxHeight ? box.maxWidth : box.maxHeight;
        return Stack(alignment: Alignment.center, children: [
          Container(
            width: s * 0.98,
            height: s * 0.98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: C.cyan.withOpacity(.35)),
            ),
          ),
          // AI match card
          Positioned(
            top: box.maxHeight * 0.26,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: C.navy, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FIXLY AI · 94% MATCH',
                      style: GoogleFonts.manrope(
                          fontSize: 10,
                          letterSpacing: .8,
                          fontWeight: FontWeight.w800,
                          color: C.cyan)),
                  const SizedBox(height: 6),
                  Text('AC not cooling. Best fit: Ahmed, AC Specialist.',
                      style: GoogleFonts.manrope(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: .94,
                      minHeight: 5,
                      backgroundColor: Color(0xFF22395A),
                      valueColor: AlwaysStoppedAnimation(C.cyan),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Technician card
          Positioned(
            bottom: box.maxHeight * 0.12,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: _cardDeco(r: 16),
              child: Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: C.blueTint, shape: BoxShape.circle),
                  child: Text('AH',
                      style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: C.blue)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ahmed Hassan',
                          style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: C.navy)),
                      Text('4.8 · 1.2 km · 8 min',
                          style: GoogleFonts.manrope(
                              fontSize: 10, color: C.grey)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: C.greenTint,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('Verified',
                      style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: C.green)),
                ),
              ]),
            ),
          ),
        ]);
      }),
    );
  }
}

// ---------- Page 3 art ----------
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = const Color(0xFFD5DEEC);
    for (final fx in [0.2, 0.7, 0.92]) {
      canvas.drawRect(
          Rect.fromLTWH(size.width * fx - 6, 0, 12, size.height), road);
    }
    for (final fy in [0.2, 0.42, 0.75]) {
      canvas.drawRect(
          Rect.fromLTWH(0, size.height * fy - 6, size.width, 12), road);
    }

    final start = Offset(size.width * 0.2, size.height * 0.75);
    final end = Offset(size.width * 0.92, size.height * 0.2);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(start.dx, size.height * 0.42)
      ..lineTo(size.width * 0.7, size.height * 0.42)
      ..lineTo(size.width * 0.7, end.dy)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(
        path,
        Paint()
          ..color = C.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);

    canvas.drawCircle(start, 7, Paint()..color = C.navy);
    canvas.drawCircle(end, 14, Paint()..color = Colors.white);
    canvas.drawCircle(end, 10, Paint()..color = C.cyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _MapArt extends StatelessWidget {
  const _MapArt();

  @override
  Widget build(BuildContext context) {
    return _ArtFrame(
      color: C.blueTint,
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: _cardDeco(r: 16),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('On the way',
                        style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: C.navy)),
                    Text('Ahmed arrives in 7 min',
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: C.grey)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                    color: C.blueTint,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Live',
                    style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: C.blue)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
