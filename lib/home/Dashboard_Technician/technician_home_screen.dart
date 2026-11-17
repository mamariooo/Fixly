import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/database/firestore_paths.dart';
import '../../core/database/user_repository.dart';
import '../../core/models/booking.dart';
import '../../core/services/booking_store.dart';
import '../../core/services/notification_store.dart';
import '../home.dart';
import '../notification_screen.dart';
import 'Earnings.dart';
import 'History.dart';
import 'Profile.dart';

const Color kNavy = Color(0xFF1C3358);
const Color kGrey = Color(0xFF8492A6);
const Color kBg = Color(0xFFF5F7FB);
const Color kBorder = Color(0xFFE5EAF1);
const Color kBlue = Color(0xFF1B4FA8);

TextStyle _text(double size, FontWeight weight, Color color) {
  return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
}

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  final UserRepository _userRepo = UserRepository();

  bool isOnline = true;
  int seconds = 24;
  int tabIndex = 0;
  Timer? timer;

  String _techName = 'أحمد حسن';
  String _techArea = 'مدينة نصر، القاهرة';

  @override
  void initState() {
    super.initState();
    _loadTechnicianProfile();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (seconds <= 0) {
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  Future<void> _loadTechnicianProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      setState(() => _techName = user.displayName!.trim());
    }

    final appUser = await _userRepo.getUserById(user.uid);
    if (!mounted || appUser == null) return;

    setState(() {
      if (appUser.fullName.trim().isNotEmpty) {
        _techName = appUser.fullName.trim();
      }
      if (appUser.area != null && appUser.area!.trim().isNotEmpty) {
        _techArea = appUser.area!.trim();
      }
    });
  }

  Future<void> _toggleOnlineStatus(bool value) async {
    setState(() => isOnline = value);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.technicianLocations)
          .doc(uid)
          .set({
            'isOnline': value,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget stat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _text(12, FontWeight.w500, kGrey)),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(value, style: _text(20, FontWeight.w800, kNavy)),
            ),
          ],
        ),
      ),
    );
  }

  Widget chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: _text(13, FontWeight.w700, fg)),
    );
  }

  Widget info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _text(12, FontWeight.w600, kGrey)),
        Text(value, style: _text(15, FontWeight.w700, kNavy)),
      ],
    );
  }

  (Color, Color, String) _urgencyStyle(String urgency) {
    switch (urgency) {
      case 'High':
        return (const Color(0xFFFDE2E1), const Color(0xFFB42318), 'عالية');
      case 'Low':
        return (const Color(0xFFDDF3E6), const Color(0xFF14733A), 'منخفضة');
      default:
        return (const Color(0xFFFDEBC8), const Color(0xFF8A5300), 'متوسطة');
    }
  }

  Widget _statsRow() {
    return ListenableBuilder(
      listenable: BookingStore.instance,
      builder: (context, _) {
        final done = BookingStore.instance.completedJobs;
        final earnings = done.fold<int>(0, (acc, b) => acc + (b.price ?? 0));
        final rated = done.where((b) => b.rating != null).toList();
        final avg = rated.isEmpty
            ? '4.9'
            : (rated.fold<int>(0, (acc, b) => acc + b.rating!) / rated.length)
                  .toStringAsFixed(1);

        return Row(
          children: [
            stat('شغل مكتمل', '${done.length}'),
            const SizedBox(width: 8),
            stat('الأرباح', '$earnings ج.م'),
            const SizedBox(width: 8),
            stat('التقييم', avg),
          ],
        );
      },
    );
  }

  /// حوار تحديد السعر وقبول الطلب
  Future<void> _acceptWithPriceDialog(Booking req) async {
    final priceCtrl = TextEditingController(
      text: (req.proposedPrice ?? 250).toString(),
    );
    final notesCtrl = TextEditingController();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'قبول الطلب وتحديد السعر النهائي',
                style: _text(20, FontWeight.w800, kNavy),
              ),
              const SizedBox(height: 6),
              Text(
                'أدخل السعر المقترح للخدمة شاملاً المعاينة والمصنعية بالجنيه المصري ليراه العميل ويختار طريقة الدفع (كاش أو فيزا):',
                style: _text(13, FontWeight.w500, kGrey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                style: _text(18, FontWeight.w800, kNavy),
                decoration: InputDecoration(
                  labelText: 'السعر النهائي (ج.م)',
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Color(0xFF1F9D63),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                style: _text(14, FontWeight.w600, kNavy),
                decoration: InputDecoration(
                  labelText: 'ملاحظات إضافية للعميل (اختياري)',
                  hintText: 'مثال: السعر يشمل المصنعية وقطع الغيار الأصلية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    final p = int.tryParse(priceCtrl.text.trim());
                    if (p == null || p <= 0) return;
                    Navigator.pop(ctx, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F9D63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'تأكيد وإرسال السعر للعميل',
                    style: _text(16, FontWeight.w800, Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      final price = int.tryParse(priceCtrl.text.trim()) ?? 250;
      await BookingStore.instance.accept(
        req,
        proposedPrice: price,
        technicianName: _techName,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم قبول الطلب وتحديد السعر النهائي: $price ج.م'),
        ),
      );
    }
  }

  // ---------- الطلبات الواردة ----------
  Widget _incomingRequest() {
    return ListenableBuilder(
      listenable: BookingStore.instance,
      builder: (context, _) {
        final requests = BookingStore.instance.pendingRequests;

        if (requests.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.access_time, color: kGrey, size: 30),
                ),
                const SizedBox(height: 16),
                Text(
                  'مفيش طلبات جديدة',
                  style: _text(22, FontWeight.w800, kNavy),
                ),
                const SizedBox(height: 6),
                Text(
                  'أول ما عميل يطلب فني أو يرشحك AI هيظهر هنا فوراً.',
                  style: _text(14, FontWeight.w500, kGrey),
                ),
              ],
            ),
          );
        }

        final req = requests.first;
        final (bg, fg, urgencyLabel) = _urgencyStyle(req.urgency);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF14B8D6), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  chip(
                    'طلب جديد',
                    const Color(0xFFDCE9FF),
                    const Color(0xFF1B4FA8),
                  ),
                  chip(urgencyLabel, bg, fg),
                  if (req.needsExpert)
                    chip(
                      'مطلوب خبير معتمد ★',
                      const Color(0xFFFFF3D6),
                      const Color(0xFF8A5300),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(req.issue, style: _text(20, FontWeight.w800, kNavy)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  info('الخدمة', req.service),
                  info('الأهمية', urgencyLabel),
                ],
              ),
              const SizedBox(height: 10),
              info('العميل', req.clientName ?? 'عميل Fixly'),
              const SizedBox(height: 8),
              info('العنوان', req.address ?? 'غير محدد'),

              // ملخص تشخيص الذكاء الاصطناعي
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F5FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF0E7490),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ملخص الذكاء الاصطناعي (AI Technical Brief)',
                          style: _text(
                            13,
                            FontWeight.w800,
                            const Color(0xFF0E7490),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      req.aiSummary != null && req.aiSummary!.isNotEmpty
                          ? req.aiSummary!
                          : 'قام العميل بوصف العطل: ${req.issue}، وينصح بالفحص والمعاينة.',
                      style: _text(13, FontWeight.w600, kNavy),
                    ),
                  ],
                ),
              ),

              // صور العطل المرفقة
              if (req.photoUrls.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'الصور المرفقة من العميل:',
                  style: _text(13, FontWeight.w700, kNavy),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: req.photoUrls.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, idx) {
                      final p = req.photoUrls[idx];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: !kIsWeb && File(p).existsSync()
                            ? Image.file(
                                File(p),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 90,
                                height: 90,
                                color: const Color(0xFFE5EAF1),
                                child: const Icon(Icons.image, color: kGrey),
                              ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        BookingStore.instance.decline(req);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم رفض الطلب')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: kBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'رفض',
                        style: _text(16, FontWeight.w800, kNavy),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptWithPriceDialog(req),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF1F9D63),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'قبول وتحديد السعر',
                        style: _text(15, FontWeight.w800, Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- الشغل الجاري ----------
  Widget _currentJob() {
    return ListenableBuilder(
      listenable: BookingStore.instance,
      builder: (context, _) {
        final jobs = BookingStore.instance.technicianJobs;

        if (jobs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: kBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مفيش شغل جاري',
                        style: _text(16, FontWeight.w800, kNavy),
                      ),
                      Text(
                        'الشغل اللي بتقبله هيظهر هنا وتحدث حالته خطوة بخطوة.',
                        style: _text(12, FontWeight.w500, kGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final job = jobs.first;
        String statusText;
        String buttonText;
        switch (job.status) {
          case BookingStatus.accepted:
            statusText =
                'تم القبول · السعر المحدد: ${job.price ?? 250} ج.م · جاهز للتحرك';
            buttonText = 'أنا في الطريق للعميل';
            break;
          case BookingStatus.onTheWay:
            statusText = 'أنت في الطريق للعميل حالياً';
            buttonText = 'وصلت وبدأت الصيانة';
            break;
          default:
            statusText = 'جاري العمل الآن';
            buttonText = 'إنهاء الشغل واستلام الحساب';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(job.icon, color: kBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.issue,
                          style: _text(16, FontWeight.w800, kNavy),
                        ),
                        Text(
                          statusText,
                          style: _text(
                            12,
                            FontWeight.w600,
                            const Color(0xFF1F9D63),
                          ),
                        ),
                        if (job.address != null)
                          Text(
                            job.address!,
                            style: _text(12, FontWeight.w500, kGrey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: job.status == BookingStatus.inProgress
                      ? () => _finishJob(job)
                      : () async {
                          await BookingStore.instance.advance(job);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: _text(15, FontWeight.w800, Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _finishJob(Booking job) async {
    final ctrl = TextEditingController(text: (job.price ?? 250).toString());

    final price = await showDialog<int>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'إنهاء الشغل وتأكيد الحساب',
            style: _text(18, FontWeight.w800, kNavy),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تأكيد المبلغ النهائي المطلوب من العميل:',
                style: _text(13, FontWeight.w500, kGrey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                style: _text(18, FontWeight.w800, kNavy),
                decoration: InputDecoration(
                  labelText: 'المبلغ الإجمالي (ج.م)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final p = int.tryParse(ctrl.text.trim());
                if (p == null || p <= 0) return;
                Navigator.pop(ctx, p);
              },
              child: const Text('تأكيد الإنجاز'),
            ),
          ],
        ),
      ),
    );

    ctrl.dispose();
    if (price == null) return;
    await BookingStore.instance.advance(job, price: price);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنهاء الشغل بنجاح وإرسال الفاتورة للعميل'),
      ),
    );
  }

  // الصفحة الرئيسية للفني
  Widget buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر مع زر التبديل إلى وضع العميل
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مساء الخير يا $_techName',
                        style: _text(22, FontWeight.w800, kNavy),
                      ),
                      Text(
                        'منطقة الخدمة: $_techArea',
                        style: _text(13, FontWeight.w500, kGrey),
                      ),
                    ],
                  ),
                ),

                // زر التبديل السريع إلى وضع العميل
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (r) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1B4FA8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.swap_horiz,
                          color: Color(0xFF1B4FA8),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'وضع العميل',
                          style: _text(
                            12,
                            FontWeight.w800,
                            const Color(0xFF1B4FA8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: ListenableBuilder(
                    listenable: NotificationStore.instance,
                    builder: (context, _) {
                      final unread = NotificationStore.instance.unreadCount(
                        NotificationAudience.technician,
                      );
                      return IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(
                              audience: NotificationAudience.technician,
                              arabic: true,
                            ),
                          ),
                        ),
                        icon: Badge(
                          isLabelVisible: unread > 0,
                          label: Text('$unread'),
                          child: const Icon(
                            Icons.notifications_none,
                            color: kNavy,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // كارت الحالة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kNavy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حالة الاستقبال',
                          style: _text(
                            13,
                            FontWeight.w600,
                            const Color(0xFF9DB0D3),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOnline ? 'متصل الآن' : 'غير متصل',
                              style: _text(24, FontWeight.w800, Colors.white),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 6,
                              backgroundColor: isOnline
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFF9DB0D3),
                            ),
                          ],
                        ),
                        Text(
                          isOnline
                              ? 'جاهز لاستقبال طلبات العملاء'
                              : 'لن تصلك طلبات جديدة',
                          style: _text(
                            12,
                            FontWeight.w500,
                            const Color(0xFF9DB0D3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOnline,
                    onChanged: _toggleOnlineStatus,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF14B8D6),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFF9DB0D3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _statsRow(),
            const SizedBox(height: 20),

            // الطلبات الواردة
            if (isOnline)
              _incomingRequest()
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kBorder),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.access_time, color: kGrey, size: 30),
                    const SizedBox(height: 12),
                    Text(
                      'أنت غير متصل حالياً',
                      style: _text(18, FontWeight.w800, kNavy),
                    ),
                    Text(
                      'قم بتفعيل زر الاتصال لاستقبال طلبات الصيانة.',
                      style: _text(13, FontWeight.w500, kGrey),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            _currentJob(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      const JobsTab(),
      const TechnicianEarningsScreen(),
      const TechnicianProfileScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBg,
        body: IndexedStack(index: tabIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabIndex,
          onTap: (index) => setState(() => tabIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: kNavy,
          unselectedItemColor: kGrey,
          selectedLabelStyle: _text(12, FontWeight.w800, kNavy),
          unselectedLabelStyle: _text(12, FontWeight.w600, kGrey),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'الشغل',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments_outlined),
              activeIcon: Icon(Icons.payments),
              label: 'الأرباح',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
