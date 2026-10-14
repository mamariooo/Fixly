import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/Login/Login.dart';

const Color _cyan = Color(0xFF14B8D6);
const Color _greenBg = Color(0xFFDDF3E6);
const Color _greenText = Color(0xFF14733A);
const Color _amberBg = Color(0xFFFDEBC8);
const Color _amberText = Color(0xFF8A5300);
const Color _lightBlueBg = Color(0xFFE3EEFF);
const Color _blueText = Color(0xFF1B4FA8);
const Color _redBg = Color(0xFFFDE2E1);
const Color _redText = Color(0xFFB42318);
const Color _roundBtnBg = Color(0xFFEEF2F8);
const Color _trackBg = Color(0xFFE6EAF2);

// ============================================================
// Model
// ============================================================
enum _Role { user, ai, summary }

class _ChatMessage {
  final _Role role;
  final String? text;
  final List<String> options; // أزرار الرد السريع (Yes / No / Not sure)

  // بيانات كارت "What I understood"
  final String? service;
  final String? urgency;
  final String? issue;
  final double? confidence;

  const _ChatMessage.user(this.text)
      : role = _Role.user,
        options = const [],
        service = null,
        urgency = null,
        issue = null,
        confidence = null;

  const _ChatMessage.ai(this.text, {this.options = const []})
      : role = _Role.ai,
        service = null,
        urgency = null,
        issue = null,
        confidence = null;

  const _ChatMessage.summary({
    required this.service,
    required this.urgency,
    required this.issue,
    required this.confidence,
  })  : role = _Role.summary,
        text = null,
        options = const [];
}

// ============================================================
// Screen
// ============================================================
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  // محادثة تجريبية مطابقة للتصميم.
  // استبدلها بالرد الحقيقي من الـ AI بتاعك.
  final List<_ChatMessage> _messages = [
    const _ChatMessage.user('The AC is running but it’s not cooling.'),
    const _ChatMessage.ai('It sounds like your AC may have a cooling or airflow issue.'),
    const _ChatMessage.summary(
      service: 'Air Conditioning',
      urgency: 'Medium',
      issue: 'Cooling / Airflow Problem',
      confidence: 0.87,
    ),
    const _ChatMessage.ai(
      'Is the AC making any unusual sounds?',
      options: ['Yes', 'No', 'Not sure'],
    ),
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage.user(t));
      // TODO: ابعت الرسالة للـ AI وضيف الرد هنا
    });
    _inputCtrl.clear();
    _scrollToBottom();
  }

  // ---------- Header ----------
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                border: Border.all(color: kBorder.withOpacity(0.6)),
              ),
              child: const Icon(Icons.chevron_left, color: kNavy, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Fixly AI',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _greenBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Online',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _greenText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Tell me what’s wrong and I’ll help you find the right technician.',
                  style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Bubbles ----------
  Widget _userBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: const BoxDecoration(
            color: kNavy,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 18,
              height: 1.35,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: kNavy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.auto_awesome, color: _cyan, size: 20),
    );
  }

  Widget _aiBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder.withOpacity(0.7)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(6),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 18,
          height: 1.35,
          color: kNavy,
        ),
      ),
    );
  }

  Widget _aiRow(Widget content, {bool showAvatar = true, List<String> options = const [], bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        showAvatar ? _avatar() : const SizedBox(width: 46),
        const SizedBox(width: 14),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
              if (options.isNotEmpty && isLast) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: options.map(_optionChip).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _optionChip(String label) {
    return InkWell(
      onTap: () => _send(label),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kNavy, width: 1.6),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
      ),
    );
  }

  // ---------- Summary card ----------
  Widget _smallLabel(String t) => Text(
        t,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: kGrey,
        ),
      );

  Widget _summaryCard(_ChatMessage m) {
    final percent = ((m.confidence ?? 0) * 100).round();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kBorder.withOpacity(0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: kNavy,
            child: Text(
              'WHAT I UNDERSTOOD',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
                color: _cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _smallLabel('DETECTED SERVICE'),
                          const SizedBox(height: 4),
                          Text(
                            m.service ?? '',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: kNavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _smallLabel('URGENCY'),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: _amberBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              m.urgency ?? '',
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: _amberText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _smallLabel('POSSIBLE ISSUE'),
                const SizedBox(height: 4),
                Text(
                  m.issue ?? '',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _smallLabel('AI CONFIDENCE'),
                    Text(
                      '$percent%',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: m.confidence ?? 0,
                    minHeight: 8,
                    color: _cyan,
                    backgroundColor: _trackBg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Messages list ----------
  Widget _messageItem(int i) {
    final m = _messages[i];
    final isLast = i == _messages.length - 1;

    switch (m.role) {
      case _Role.user:
        return _userBubble(m.text ?? '');
      case _Role.ai:
        return _aiRow(
          _aiBubble(m.text ?? ''),
          options: m.options,
          isLast: isLast,
        );
      case _Role.summary:
        return _aiRow(_summaryCard(m), showAvatar: false);
    }
  }

  // ---------- Bottom bar ----------
  Widget _quickAction(String label, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
        ),
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap,
      {bool filled = false}) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: filled ? kNavy : _roundBtnBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: filled ? Colors.white : kNavy, size: 24),
      ),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _quickAction('Add a photo', _lightBlueBg, _blueText, () {
                  // TODO: pick photo
                }),
                _quickAction('It’s an emergency', _redBg, _redText,
                    () => _send('It’s an emergency')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 6, 8, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: kBorder, width: 1.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    onSubmitted: _send,
                    textInputAction: TextInputAction.send,
                    style: GoogleFonts.manrope(fontSize: 17, color: kNavy),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Describe your problem...',
                      hintStyle:
                          GoogleFonts.manrope(fontSize: 17, color: kGrey),
                    ),
                  ),
                ),
                _roundButton(Icons.photo_camera_outlined, () {
                  // TODO: camera
                }),
                const SizedBox(width: 8),
                _roundButton(Icons.mic_none, () {
                  // TODO: voice
                }),
                const SizedBox(width: 8),
                _roundButton(
                  Icons.near_me_outlined,
                  () => _send(_inputCtrl.text),
                  filled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView.separated(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  // رسايل اليوزر محتاجة padding يمين
                  return m.role == _Role.user
                      ? Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: _messageItem(i),
                        )
                      : _messageItem(i);
                },
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }
}