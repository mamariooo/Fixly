import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

const Color _cyan = Color(0xFF14B8D6);
const Color _chipBg = Color(0xFFDCE9FF);
const Color _chipText = Color(0xFF1B4FA8);
const Color _hintText = Color(0xFF0E7490);

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool _listening = false;
  String? _transcript;

  static const _samples = [
    'The AC is running but it’s not cooling.',
    'فيه تسريب مياه تحت الحوض',
    'The socket in my room is not working',
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _listening = !_listening;
      if (_listening) _transcript = null;
    });
    if (_listening) {
      _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 0;
      // نص وهمي بدل التعرف الحقيقي على الصوت
      setState(() {
        _transcript = _samples[DateTime.now().millisecond % _samples.length];
      });
    }
  }

  Widget _ring(double size, Color color, Animation<double> scale) {
    return ScaleTransition(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _micArea() {
    final outerScale = Tween<double>(
      begin: 1.0,
      end: 1.10,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    final midScale = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    return GestureDetector(
      onTap: _toggleListening,
      child: SizedBox(
        width: 230,
        height: 230,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _ring(200, _cyan.withValues(alpha: 0.12), outerScale),
            _ring(146, _cyan.withValues(alpha: 0.24), midScale),
            Container(
              width: 98,
              height: 98,
              decoration: const BoxDecoration(
                color: kNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_none, color: Colors.white, size: 38),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              // Top bar: close + Voice chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: kBorder.withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Icon(Icons.close, color: kNavy, size: 24),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _chipBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Voice',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _chipText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Tell us what\'s wrong',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Speak naturally in Arabic or English.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 17, color: kGrey),
              ),
              const SizedBox(height: 44),

              _micArea(),
              const SizedBox(height: 16),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _listening
                      ? 'Listening... tap to stop'
                      : 'Tap the mic to speak',
                  key: ValueKey(_listening),
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _hintText,
                  ),
                ),
              ),
              if (_transcript != null) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WE HEARD',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _transcript!,
                        style: GoogleFonts.manrope(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: kNavy,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _transcript = null),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          foregroundColor: kNavy,
                          side: const BorderSide(color: kBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Try again'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, _transcript),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Send to AI'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
