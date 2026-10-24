import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:fixly/Login/Login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fixly/home/voice_screen.dart';
import 'package:fixly/core/services/booking_store.dart';
import 'package:fixly/core/services/profile_store.dart';
=======

import 'package:fixly/Login/Login.dart';
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

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
<<<<<<< HEAD
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
=======
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
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

  const _ChatMessage.summary({
    required this.service,
    required this.urgency,
    required this.issue,
    required this.confidence,
<<<<<<< HEAD
  }) : role = _Role.summary,
       text = null,
       options = const [];
=======
  })  : role = _Role.summary,
        text = null,
        options = const [];
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
}

// ============================================================
// Screen
// ============================================================
class AiChatScreen extends StatefulWidget {
<<<<<<< HEAD
  const AiChatScreen({super.key, this.initialMessage});

  final String? initialMessage;
=======
  const AiChatScreen({super.key});
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
<<<<<<< HEAD
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;
  final Set<int> _requested = {};

  final List<_ChatMessage> _messages = [
    const _ChatMessage.user('The AC is running but it’s not cooling.'),
    const _ChatMessage.ai(
      'It sounds like your AC may have a cooling or airflow issue.',
    ),
=======

  // محادثة تجريبية مطابقة للتصميم.
  // استبدلها بالرد الحقيقي من الـ AI بتاعك.
  final List<_ChatMessage> _messages = [
    const _ChatMessage.user('The AC is running but it’s not cooling.'),
    const _ChatMessage.ai('It sounds like your AC may have a cooling or airflow issue.'),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
  void initState() {
    super.initState();
    final first = widget.initialMessage;
    if (first != null && first.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _send(first));
    }
  }

  @override
=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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

<<<<<<< HEAD
  // رد وهمي حسب كلمات في الرسالة (بدل الـ AI الحقيقي)
  List<_ChatMessage> _mockReply(String text) {
    final t = text.toLowerCase();

    bool has(List<String> words) => words.any(t.contains);

    if (has([
      'emergency',
      'طوارئ',
      'gas',
      'غاز',
      'spark',
      'شرار',
      'fire',
      'حريق',
    ])) {
      return [
        const _ChatMessage.ai(
          'This sounds urgent. Please stay safe, and I will look for the nearest available technician right away.',
        ),
        const _ChatMessage.summary(
          service: 'Emergency',
          urgency: 'High',
          issue: 'Urgent safety issue',
          confidence: 0.92,
        ),
      ];
    }
    if (has(['ac', 'تكييف', 'cooling', 'air condition'])) {
      return [
        const _ChatMessage.ai(
          'It sounds like your AC may have a cooling or airflow issue.',
        ),
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
    }
    if (has([
      'leak',
      'pipe',
      'water',
      'plumb',
      'تسريب',
      'سباك',
      'مياه',
      'ماسورة',
    ])) {
      return [
        const _ChatMessage.ai('This looks like a plumbing problem.'),
        const _ChatMessage.summary(
          service: 'Plumbing',
          urgency: 'Medium',
          issue: 'Water leak',
          confidence: 0.82,
        ),
        const _ChatMessage.ai(
          'Is the water still running right now?',
          options: ['Yes', 'No', 'Not sure'],
        ),
      ];
    }
    if (has(['light', 'power', 'electric', 'socket', 'كهرب', 'نور', 'فيش'])) {
      return [
        const _ChatMessage.ai('This looks like an electrical problem.'),
        const _ChatMessage.summary(
          service: 'Electrical',
          urgency: 'Medium',
          issue: 'Power / wiring issue',
          confidence: 0.8,
        ),
        const _ChatMessage.ai(
          'Did the problem start suddenly?',
          options: ['Yes', 'No', 'Not sure'],
        ),
      ];
    }
    if (t == 'yes' || t == 'no' || t == 'not sure') {
      return [
        const _ChatMessage.ai(
          'Thanks, that helps. I can show you the best technicians for this job now.',
        ),
      ];
    }
    return [
      const _ChatMessage.ai(
        'Can you tell me more? For example: which appliance or room, and what exactly is happening?',
      ),
    ];
  }

  Future<void> _reply(String userText) async {
    setState(() => _isTyping = true);
    _scrollToBottom();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.addAll(_mockReply(userText));
    });
    _scrollToBottom();
  }

  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty || _isTyping) return;
    setState(() => _messages.add(_ChatMessage.user(t)));
    _inputCtrl.clear();
    _scrollToBottom();
    _reply(t);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 80);
      if (file == null || !mounted) return;
      setState(
        () => _messages.add(_ChatMessage.user('📷 Photo: ${file.name}')),
      );
      _scrollToBottom();
      setState(() => _isTyping = true);
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          const _ChatMessage.ai(
            'Thanks for the photo. Can you also describe what is wrong in a few words?',
          ),
        );
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the camera/gallery')),
      );
    }
=======
  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage.user(t));
      // TODO: ابعت الرسالة للـ AI وضيف الرد هنا
    });
    _inputCtrl.clear();
    _scrollToBottom();
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                border: Border.all(color: kBorder.withValues(alpha: 0.6)),
=======
                border: Border.all(color: kBorder.withOpacity(0.6)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                        horizontal: 12,
                        vertical: 4,
                      ),
=======
                          horizontal: 12, vertical: 4),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
=======
        border: Border.all(color: kBorder.withOpacity(0.7)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(6),
        ),
      ),
      child: Text(
        text,
<<<<<<< HEAD
        style: GoogleFonts.manrope(fontSize: 18, height: 1.35, color: kNavy),
=======
        style: GoogleFonts.manrope(
          fontSize: 18,
          height: 1.35,
          color: kNavy,
        ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
      ),
    );
  }

<<<<<<< HEAD
  Widget _aiRow(
    Widget content, {
    bool showAvatar = true,
    List<String> options = const [],
    bool isLast = false,
  }) {
=======
  Widget _aiRow(Widget content, {bool showAvatar = true, List<String> options = const [], bool isLast = false}) {
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
    t,
    style: GoogleFonts.manrope(
      fontSize: 13,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
      color: kGrey,
    ),
  );
=======
        t,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: kGrey,
        ),
      );
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

  Widget _summaryCard(_ChatMessage m) {
    final percent = ((m.confidence ?? 0) * 100).round();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
<<<<<<< HEAD
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
=======
        border: Border.all(color: kBorder.withOpacity(0.7)),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                              horizontal: 14,
                              vertical: 6,
                            ),
=======
                                horizontal: 14, vertical: 6),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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

<<<<<<< HEAD
 Future<String?> _askAddress() async {
    final ctrl = TextEditingController();
    String? error;

    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Where should the technician come?'),
          content: TextField(
            controller: ctrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Street, building, floor, area',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final t = ctrl.text.trim();
                if (t.length < 5) {
                  setLocal(() => error = 'Enter a full address');
                  return;
                }
                Navigator.pop(ctx, t);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestTechnician(int index, _ChatMessage m) async {
    final profile = ProfileStore.instance;
    String? address = profile.defaultAddress?.address;

    if (address == null) {
      address = await _askAddress();
      if (address == null || !mounted) return;
      profile.addAddress('Home', address); // بيتحفظ كعنوان افتراضي
    }

    BookingStore.instance.create(
      service: m.service ?? 'Other',
      issue: m.issue ?? 'Service request',
      urgency: m.urgency ?? 'Medium',
      address: address,
      paymentMethod: profile.defaultPayment.label,
    );

    setState(() {
      _requested.add(index);
      _messages.add(_ChatMessage.ai(
        'Your request was sent. The technician will come to: $address. '
        'You can follow it from the Bookings tab.',
      ));
    });
    _scrollToBottom();
  }

=======
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
        return _aiRow(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(m),
              const SizedBox(height: 12),
              if (_requested.contains(i))
                Text(
                  'Request sent ✓',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF14733A),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _requestTechnician(i, m),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Request a technician',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          showAvatar: false,
        );
=======
        return _aiRow(_summaryCard(m), showAvatar: false);
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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

<<<<<<< HEAD
  Widget _roundButton(
    IconData icon,
    VoidCallback onTap, {
    bool filled = false,
  }) {
=======
  Widget _roundButton(IconData icon, VoidCallback onTap,
      {bool filled = false}) {
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                _quickAction(
                  'Add a photo',
                  _lightBlueBg,
                  _blueText,
                  () => _pickPhoto(ImageSource.gallery),
                ),

                _quickAction(
                  'It’s an emergency',
                  _redBg,
                  _redText,
                  () => _send('It’s an emergency'),
                ),
=======
                _quickAction('Add a photo', _lightBlueBg, _blueText, () {
                  // TODO: pick photo
                }),
                _quickAction('It’s an emergency', _redBg, _redText,
                    () => _send('It’s an emergency')),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                      hintStyle: GoogleFonts.manrope(
                        fontSize: 17,
                        color: kGrey,
                      ),
                    ),
                  ),
                ),
                _quickAction(
                  'Add a photo',
                  _lightBlueBg,
                  _blueText,
                  () => _pickPhoto(ImageSource.gallery),
                ),

                _roundButton(Icons.mic_none, () async {
                  final text = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (_) => const VoiceScreen()),
                  );
                  if (text != null && mounted) _send(text);
=======
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
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 18),
                itemBuilder: (_, i) {
                  if (i == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Text(
                        'Fixly AI is typing...',
                        style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                      ),
                    );
                  }
                  final m = _messages[i];

=======
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  // رسايل اليوزر محتاجة padding يمين
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
}
=======
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
