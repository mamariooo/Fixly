import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/models/technician_model.dart';
import '../core/services/booking_store.dart';
import '../core/services/database_seeder.dart';
import '../core/services/fixly_ai_service.dart';
import '../core/services/profile_store.dart';
import '../core/theme/app_colors.dart';
import '../main.dart';
import 'BookingsTab.dart';

const Color _cyan = Color(0xFF14B8D6);
const Color _roundBtnBg = Color(0xFFEEF2F8);
const Color _trackBg = Color(0xFFE6EAF2);

enum _Role { user, ai, summary, techRecommendation, success }

class _ChatMessage {
  final _Role role;
  final String? text;
  final List<String> options;

  // بيانات كارت التشخيص (AI Diagnosis)
  final String? service;
  final String? urgency;
  final String? issue;
  final bool needsExpert;
  final double? confidence;
  final String? safetyAdvice;
  final String? technicianBrief;

  // صور مرفقة
  final String? photoPath;
  final Uint8List? photoBytes;

  // فنيون مرشحون
  final List<TechnicianModel>? recommendedTechnicians;
  final TechnicianModel? selectedTech;

  const _ChatMessage.user(this.text, {this.photoPath, this.photoBytes})
    : role = _Role.user,
      options = const [],
      service = null,
      urgency = null,
      issue = null,
      needsExpert = false,
      confidence = null,
      safetyAdvice = null,
      technicianBrief = null,
      recommendedTechnicians = null,
      selectedTech = null;

  const _ChatMessage.ai(this.text, {this.options = const []})
    : role = _Role.ai,
      service = null,
      urgency = null,
      issue = null,
      needsExpert = false,
      confidence = null,
      safetyAdvice = null,
      technicianBrief = null,
      photoPath = null,
      photoBytes = null,
      recommendedTechnicians = null,
      selectedTech = null;

  const _ChatMessage.summary({
    required this.service,
    required this.urgency,
    required this.issue,
    required this.needsExpert,
    required this.confidence,
    required this.safetyAdvice,
    required this.technicianBrief,
  }) : role = _Role.summary,
       text = null,
       options = const [],
       photoPath = null,
       photoBytes = null,
       recommendedTechnicians = null,
       selectedTech = null;

  const _ChatMessage.recommendation(
    this.recommendedTechnicians, {
    this.service,
    this.issue,
    this.urgency,
    this.needsExpert = false,
    this.technicianBrief,
  }) : role = _Role.techRecommendation,
       text = null,
       options = const [],
       confidence = null,
       safetyAdvice = null,
       photoPath = null,
       photoBytes = null,
       selectedTech = null;

  const _ChatMessage.success(this.text, {this.selectedTech})
    : role = _Role.success,
      options = const [],
      service = null,
      urgency = null,
      issue = null,
      needsExpert = false,
      confidence = null,
      safetyAdvice = null,
      technicianBrief = null,
      photoPath = null,
      photoBytes = null,
      recommendedTechnicians = null;
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({
    super.key,
    this.initialMessage,
    this.preSelectedTechnician,
    this.initialPhotoPath,
    this.initialPhotoBytes,
  });

  final String? initialMessage;
  final TechnicianModel? preSelectedTechnician;
  final String? initialPhotoPath;
  final Uint8List? initialPhotoBytes;

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final ImagePicker _picker = ImagePicker();

  bool _isTyping = false;
  bool _isCreatingBooking = false;
  final Set<String> _requestedTechIds = {};
  final List<String> _attachedPhotos = [];

  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    // رسالة الترحيب الافتراضية
    _messages.add(
      const _ChatMessage.ai(
        'مرحباً بك! أنا مساعد Fixly الذكي للصيانة. اشرح لي المشكلة التي تواجهها أو أرفق صورة وسأقوم بتشخيصها وترشيح الفني الأنسب لك.',
        options: [
          'التكييف مش بيسقع وبيطلع صوت',
          'عندي تسريب مياه في المطبخ',
          'فيشة أو مفتاح كهرباء بيشرز',
        ],
      ),
    );

    // إذا تم تمرير رسالة أو صورة مسبقاً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialPhotoPath != null || widget.initialPhotoBytes != null) {
        _handleIncomingPhoto(
          widget.initialPhotoPath,
          widget.initialPhotoBytes,
          widget.initialMessage,
        );
      } else if (widget.initialMessage != null &&
          widget.initialMessage!.trim().isNotEmpty) {
        _send(widget.initialMessage!);
      }
    });
  }

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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleIncomingPhoto(
    String? path,
    Uint8List? bytes,
    String? initialText,
  ) async {
    if (path != null) _attachedPhotos.add(path);

    setState(() {
      _messages.add(
        _ChatMessage.user(
          initialText ?? 'أرفقت صورة المشكلة للتحليل',
          photoPath: path,
          photoBytes: bytes,
        ),
      );
    });
    _scrollToBottom();
    await _diagnoseAndReply(initialText ?? 'فحص الصورة المرفقة', bytes: bytes);
  }

  Future<void> _diagnoseAndReply(String userText, {Uint8List? bytes}) async {
    setState(() => _isTyping = true);
    _scrollToBottom();

    try {
      // 1. تشخيص المشكلة بالذكاء الاصطناعي (Gemini أو المحرك الداخلي)
      final diagnosis = await FixlyAiService.instance.diagnoseProblem(
        description: userText,
        imageBytes: bytes,
      );

      // 2. جلب الفنيين وتطبيق خوارزمية الترشيح
      final allTechnicians = await DatabaseSeeder.instance.getTechnicians();
      final rankedTechnicians = FixlyAiService.instance.rankTechnicians(
        technicians: allTechnicians,
        diagnosis: diagnosis,
      );

      if (!mounted) return;

      setState(() {
        _isTyping = false;

        // رسالة نصيحة الأمان
        if (diagnosis.safetyAdvice.isNotEmpty) {
          _messages.add(_ChatMessage.ai(diagnosis.safetyAdvice));
        }

        // كارت ملخص فهم الذكاء الاصطناعي
        _messages.add(
          _ChatMessage.summary(
            service: diagnosis.serviceCategory,
            urgency: diagnosis.urgency,
            issue: diagnosis.issueSummary,
            needsExpert: diagnosis.needsExpert,
            confidence: diagnosis.confidence,
            safetyAdvice: diagnosis.safetyAdvice,
            technicianBrief: diagnosis.technicianBrief,
          ),
        );

        // كارت ترشيح الفنيين المتوافقين مع المشكلة
        _messages.add(
          _ChatMessage.recommendation(
            rankedTechnicians.take(3).toList(),
            service: diagnosis.serviceCategory,
            issue: diagnosis.issueSummary,
            urgency: diagnosis.urgency,
            needsExpert: diagnosis.needsExpert,
            technicianBrief: diagnosis.technicianBrief,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          const _ChatMessage.ai(
            'حدث خطأ أثناء الاتصال بالذكاء الاصطناعي، لكن يمكنك متابعة الطلب واختيار الفني المناسب.',
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty || _isTyping) return;
    setState(() => _messages.add(_ChatMessage.user(t)));
    _inputCtrl.clear();
    _scrollToBottom();
    _diagnoseAndReply(t);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 80);
      if (file == null || !mounted) return;

      final bytes = await file.readAsBytes();
      _attachedPhotos.add(file.path);

      setState(() {
        _messages.add(
          _ChatMessage.user(
            '📷 صورة مرفقة: ${file.name}',
            photoPath: file.path,
            photoBytes: bytes,
          ),
        );
      });
      _scrollToBottom();

      await _diagnoseAndReply(
        'يرجى تحليل صورة العطل المرفقة: ${file.name}',
        bytes: bytes,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الكاميرا أو المعرض')),
      );
    }
  }

  Future<String?> _askAddress() async {
    final ctrl = TextEditingController();
    String? error;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('أين موقع المشكلة؟'),
          content: TextField(
            controller: ctrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'الشارع، رقم العمارة، الطابق، والمنطقة',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final t = ctrl.text.trim();
                if (t.length < 5) {
                  setLocal(() => error = 'يرجى كتابة عنوان واضح وكامل');
                  return;
                }
                Navigator.pop(ctx, t);
              },
              child: const Text('متابعة'),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    return result;
  }

  /// إرسال الطلب للفني بالصور وملخص الـ AI
  Future<void> _sendJobToTechnician({
    required TechnicianModel tech,
    required String service,
    required String issue,
    required String urgency,
    required bool needsExpert,
    String? aiSummary,
  }) async {
    if (_isCreatingBooking) return;

    final profile = ProfileStore.instance;
    String? address = profile.defaultAddress?.address;

    if (address == null) {
      address = await _askAddress();
      if (address == null || !mounted) return;
      profile.addAddress('المنزل', address);
    }

    setState(() => _isCreatingBooking = true);

    try {
      await BookingStore.instance.create(
        service: service,
        issue: issue,
        urgency: urgency,
        address: address,
        paymentMethod: 'كاش أو فيزا',
        technicianId: tech.id,
        technicianName: tech.name,
        technicianPhone: tech.phone,
        aiSummary: aiSummary,
        needsExpert: needsExpert,
        photoUrls: List<String>.from(_attachedPhotos),
      );

      if (!mounted) return;
      setState(() {
        _requestedTechIds.add(tech.id);
        _messages.add(
          _ChatMessage.success(
            'تم إرسال الطلب بنجاح إلى الفني (${tech.name}) مع كافة تفاصيل العطل والصور المرفقة.\n'
            'الفني سيقوم بمراجعة الطلب وتحديد السعر النهائي فوراً.',
            selectedTech: tech,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إرسال الطلب: $e')));
    } finally {
      if (mounted) setState(() => _isCreatingBooking = false);
    }
  }

  // ---------- Header ----------
  Widget _header() {
    final isAr = appLocale.value.languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder.withValues(alpha: 0.6)),
              ),
              child: const Icon(Icons.arrow_back, color: kNavy, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kNavy,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_awesome, color: _cyan, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'مساعد Fixly الذكي' : 'Fixly AI Assistant',
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    Text(
                      isAr
                          ? 'تشخيص فوري وترشيح الفني الأنسب'
                          : 'Smart diagnosis & technician matching',
                      style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- الرسائل والفقاعات ----------
  Widget _userBubble(String text, {String? photoPath, Uint8List? bytes}) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: const BoxDecoration(
            color: kNavy,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bytes != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    bytes,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ] else if (photoPath != null && kIsWeb == false) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(photoPath),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                text,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aiBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder.withValues(alpha: 0.7)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(fontSize: 15, height: 1.4, color: kNavy),
      ),
    );
  }

  // ---------- كارت تشخيص الذكاء الاصطناعي ----------
  Widget _summaryCard(_ChatMessage m) {
    final isAr = appLocale.value.languageCode == 'ar';
    final percent = ((m.confidence ?? 0.9) * 100).round();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF14B8D6), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: kNavy,
            child: Row(
              children: [
                const Icon(Icons.psychology, color: _cyan, size: 20),
                const SizedBox(width: 8),
                Text(
                  isAr ? 'ملخص تشخيص FIXLY AI' : 'WHAT FIXLY AI UNDERSTOOD',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: _cyan,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'الخدمة المقترحة' : 'DETECTED SERVICE',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: kGrey,
                          ),
                        ),
                        Text(
                          m.service ?? '',
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: kNavy,
                          ),
                        ),
                      ],
                    ),
                    // بادج مستوى الخبرة المطلوبة
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: m.needsExpert
                            ? const Color(0xFFFFF3D6)
                            : const Color(0xFFDDF3E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        m.needsExpert
                            ? (isAr ? 'يحتاج خبير معتمد ★' : 'Needs Expert ★')
                            : (isAr ? 'صيانة عامة' : 'General Tech'),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: m.needsExpert
                              ? const Color(0xFF8A5300)
                              : const Color(0xFF14733A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isAr ? 'العطل المحتمل' : 'POSSIBLE ISSUE',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: kGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  m.issue ?? '',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'دقة التشخيص' : 'AI CONFIDENCE',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: kGrey,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: m.confidence ?? 0.9,
                    minHeight: 6,
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

  // ---------- كارت ترشيح الفنيين ----------
  Widget _recommendationCard(_ChatMessage m) {
    final isAr = appLocale.value.languageCode == 'ar';
    final techs = m.recommendedTechnicians ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCCE2FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.recommend, color: Color(0xFF1D5FD8), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isAr
                      ? 'الفنيون المرشحون لهذه المشكلة'
                      : 'AI Recommended Technicians',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...techs.map((tech) {
            final isRequested = _requestedTechIds.contains(tech.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: tech.isExpert
                      ? const Color(0xFFE5A93C).withValues(alpha: 0.5)
                      : kBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFDCE9FF),
                        child: Text(
                          tech.name
                              .split(' ')
                              .map((p) => p.isNotEmpty ? p[0] : '')
                              .take(2)
                              .join(),
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: kNavy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    tech.name,
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: kNavy,
                                    ),
                                  ),
                                ),
                                if (tech.isExpert) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.workspace_premium,
                                    color: Color(0xFFE5A93C),
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${tech.specialty} · ${tech.distanceKm} ${isAr ? 'كم' : 'km'}',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: kGrey,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFF5B301),
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${tech.rating}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: kNavy,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${tech.matchPercentage}%',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1B4FA8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tech.matchReason,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF1C3358),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: isRequested || _isCreatingBooking
                          ? null
                          : () => _sendJobToTechnician(
                              tech: tech,
                              service: m.service ?? 'General',
                              issue: m.issue ?? 'Service Request',
                              urgency: m.urgency ?? 'Medium',
                              needsExpert: m.needsExpert,
                              aiSummary: m.technicianBrief,
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRequested
                            ? const Color(0xFF1F9D63)
                            : kNavy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isCreatingBooking
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isRequested
                                  ? (isAr ? 'تم الإرسال ✓' : 'Sent ✓')
                                  : (isAr
                                        ? 'إرسال الطلب لـ ${tech.name.split(' ').first}'
                                        : 'Send Request to ${tech.name.split(' ').first}'),
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------- كارت تأكيد النجاح ----------
  Widget _successCard(_ChatMessage m) {
    final isAr = appLocale.value.languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F9F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB5E8C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF1F9D63),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                isAr ? 'تم إرسال طلبك بنجاح' : 'Request Sent Successfully',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF14733A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            m.text ?? '',
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.4,
              color: const Color(0xFF1C3358),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingsTab()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1F9D63)),
                foregroundColor: const Color(0xFF14733A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isAr ? 'متابعة الطلب في الحجوزات' : 'Track in Bookings Tab',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageItem(int i) {
    final m = _messages[i];
    final isLast = i == _messages.length - 1;

    switch (m.role) {
      case _Role.user:
        return _userBubble(
          m.text ?? '',
          photoPath: m.photoPath,
          bytes: m.photoBytes,
        );
      case _Role.ai:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kNavy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome, color: _cyan, size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _aiBubble(m.text ?? ''),
                  if (m.options.isNotEmpty && isLast) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: m.options.map((opt) {
                        return InkWell(
                          onTap: () => _send(opt),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kNavy, width: 1.2),
                            ),
                            child: Text(
                              opt,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: kNavy,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      case _Role.summary:
        return _summaryCard(m);
      case _Role.techRecommendation:
        return _recommendationCard(m);
      case _Role.success:
        return _successCard(m);
    }
  }

  // ---------- شريط الإدخال السفلي ----------
  Widget _inputBar() {
    final isAr = appLocale.value.languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // زر الكاميرا / المعرض
            InkWell(
              onTap: () => _pickPhoto(ImageSource.gallery),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _roundBtnBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: kNavy,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // حقل الكتابة
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kBorder),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _send,
                  style: GoogleFonts.manrope(fontSize: 15, color: kNavy),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isAr
                        ? 'اوصف المشكلة أو اسأل AI...'
                        : 'Describe problem or ask AI...',
                    hintStyle: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // زر الإرسال
            InkWell(
              onTap: () => _send(_inputCtrl.text),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kNavy,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
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
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView.separated(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _messageItem(i),
              ),
            ),
            if (_isTyping) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _cyan,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      appLocale.value.languageCode == 'ar'
                          ? 'الذكاء الاصطناعي يقوم بالتحليل...'
                          : 'Fixly AI is analyzing...',
                      style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                    ),
                  ],
                ),
              ),
            ],
            _inputBar(),
          ],
        ),
      ),
    );
  }
}
