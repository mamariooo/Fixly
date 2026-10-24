<<<<<<< HEAD
import 'dart:async';
=======

import 'dart:async';

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
import 'package:fixly/home/Dashboard_Technician/Earnings.dart';
import 'package:fixly/home/Dashboard_Technician/History.dart';
import 'package:fixly/home/Dashboard_Technician/Profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:fixly/core/services/booking_store.dart';
import 'package:fixly/core/models/booking.dart';
import 'package:fixly/core/services/notification_store.dart';
import 'package:fixly/home/notification_screen.dart';
=======
import 'package:fixly/Login/Login.dart';




>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

const Color kNavy = Color(0xFF1C3358);
const Color kGrey = Color(0xFF8492A6);
const Color kBg = Color(0xFFF5F7FB);
const Color kBorder = Color(0xFFE5EAF1);
const Color kBlue = Color(0xFF1B4FA8);

TextStyle _text(double size, FontWeight weight, Color color) {
<<<<<<< HEAD
  return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
=======
  return GoogleFonts.cairo(
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
}

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
<<<<<<< HEAD
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
=======
  State<TechnicianHomeScreen> createState() =>
      _TechnicianHomeScreenState();
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  bool isOnline = true;
  int seconds = 24;
  int tabIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

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
<<<<<<< HEAD
              child: Text(value, style: _text(20, FontWeight.w800, kNavy)),
=======
              child: Text(
                value,
                style: _text(20, FontWeight.w800, kNavy),
              ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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

<<<<<<< HEAD
  // ---------- الطلبات والشغل (من BookingStore) ----------
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
        final earnings = done.fold<int>(0, (sum, b) => sum + (b.price ?? 0));
        final rated = done.where((b) => b.rating != null).toList();
        final avg = rated.isEmpty
            ? '—'
            : (rated.fold<int>(0, (sum, b) => sum + b.rating!) / rated.length)
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
                  'أول ما عميل يطلب فني هيظهر هنا.',
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
          padding: const EdgeInsets.all(16),
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
                ],
              ),
              const SizedBox(height: 12),
              Text(req.issue, style: _text(22, FontWeight.w800, kNavy)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  info('الخدمة', req.service),
                  info('الأهمية', urgencyLabel),
                ],
              ),
              const SizedBox(height: 10),
              info('العنوان', req.address ?? 'غير محدد'),
              const SizedBox(height: 8),
              info(
                'الدفع',
                req.paymentMethod == 'Cash'
                    ? 'كاش'
                    : (req.paymentMethod ?? 'غير محدد'),
              ),
              const SizedBox(height: 16),
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
                    Text(
                      'ملخص الذكاء الاصطناعي',
                      style: _text(
                        13,
                        FontWeight.w800,
                        const Color(0xFF0E7490),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'العميل بيبلغ عن: ${req.issue} (${req.service}).',
                      style: _text(14, FontWeight.w500, kNavy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                        style: _text(17, FontWeight.w800, kNavy),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        BookingStore.instance.accept(req);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول الطلب')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFF1F9D63),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'قبول',
                        style: _text(17, FontWeight.w800, Colors.white),
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
                        'مفيش شغل جاي',
                        style: _text(17, FontWeight.w800, kNavy),
                      ),
                      Text(
                        'الشغل اللي بتقبله هيظهر هنا.',
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
            statusText = 'تم القبول · جاهز تتحرك';
            buttonText = 'أنا في الطريق';
            break;
          case BookingStatus.onTheWay:
            statusText = 'في الطريق للعميل';
            buttonText = 'وصلت وبدأت الشغل';
            break;
          default:
            statusText = 'الشغل شغال';
            buttonText = 'إنهاء الشغل';
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
                          style: _text(17, FontWeight.w800, kNavy),
                        ),
                        Text(
                          statusText,
                          style: _text(12, FontWeight.w500, kGrey)),
                          if (job.address != null)
                          Text(job.address!,
                              style: _text(12, FontWeight.w500, kGrey)),
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
                      : () => BookingStore.instance.advance(job),
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
                    style: _text(16, FontWeight.w800, Colors.white),
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
    final ctrl = TextEditingController();
    String? error;

    final price = await showDialog<int>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text(
              'إنهاء الشغل',
              style: _text(18, FontWeight.w800, kNavy),
            ),
            content: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'السعر النهائي (ج.م)',
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
                  final p = int.tryParse(ctrl.text.trim());
                  if (p == null || p <= 0) {
                    setLocal(() => error = 'اكتب سعر صحيح');
                    return;
                  }
                  Navigator.pop(ctx, p);
                },
                child: const Text('تأكيد'),
              ),
            ],
          ),
        ),
      ),
    );

    if (price == null) return;
    BookingStore.instance.advance(job, price: price);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم إنهاء الشغل')));
  }

  // الصفحة الرئيسية
  Widget buildHomePage() {
=======
  // الصفحة الرئيسية
  Widget buildHomePage() {
    final time = '0:${seconds.toString().padLeft(2, '0')}';

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مساء الخير يا أحمد',
                        style: _text(23, FontWeight.w800, kNavy),
                      ),
                      Text(
                        'منطقة الخدمة: مدينة نصر',
                        style: _text(13, FontWeight.w500, kGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                  ),
<<<<<<< HEAD
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
                          ),
                        ),
                      );
                    },
=======
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: kNavy,
                    ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحالة',
                          style: _text(
                            14,
                            FontWeight.w600,
                            const Color(0xFF9DB0D3),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isOnline ? 'متصل' : 'غير متصل',
<<<<<<< HEAD
                              style: _text(26, FontWeight.w800, Colors.white),
=======
                              style: _text(
                                26,
                                FontWeight.w800,
                                Colors.white,
                              ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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
<<<<<<< HEAD
                          isOnline ? 'بتستقبل طلبات' : 'مش هتوصلك طلبات جديدة',
=======
                          isOnline
                              ? 'بتستقبل طلبات'
                              : 'مش هتوصلك طلبات جديدة',
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                          style: _text(
                            13,
                            FontWeight.w500,
                            const Color(0xFF9DB0D3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOnline,
                    onChanged: (value) {
                      setState(() => isOnline = value);
                    },
<<<<<<< HEAD
                    activeThumbColor: Colors.white,
=======
                    activeColor: Colors.white,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
                    activeTrackColor: const Color(0xFF14B8D6),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFF9DB0D3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // الإحصائيات
<<<<<<< HEAD
            _statsRow(),
=======
            Row(
              children: [
                stat('شغل النهاردة', '5'),
                const SizedBox(width: 8),
                stat('الأرباح', '850 ج.م'),
                const SizedBox(width: 8),
                stat('التقييم', '4.8'),
              ],
            ),

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            const SizedBox(height: 20),

            // الطلب الجديد
            if (isOnline)
<<<<<<< HEAD
              _incomingRequest()
=======
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF14B8D6),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        chip(
                          'طلب جديد',
                          const Color(0xFFDCE9FF),
                          const Color(0xFF1B4FA8),
                        ),
                        chip(
                          'متوسطة',
                          const Color(0xFFFDEBC8),
                          const Color(0xFF8A5300),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'التكييف مش بيبرّد',
                      style: _text(22, FontWeight.w800, kNavy),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        info('المسافة', '1.4 كم'),
                        info('الوصول', '8 دقيقة'),
                        info('التقدير', '300–450 ج.م'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ملخص الذكاء الاصطناعي
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
                          Text(
                            'ملخص الذكاء الاصطناعي',
                            style: _text(
                              13,
                              FontWeight.w800,
                              const Color(0xFF0E7490),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'العميل بيبلغ إن التكييف شغال بس مش بيبرّد. '
                            'احتمال مشكلة تدفق هواء أو تبريد.',
                            style: _text(14, FontWeight.w500, kNavy),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      seconds > 0
                          ? 'ينتهي خلال $time'
                          : 'انتهى وقت قبول الطلب',
                      style: _text(
                        13,
                        FontWeight.w700,
                        const Color(0xFFB42318),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: seconds > 0
                                ? () {
                                    setState(() {
                                      isOnline = true;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم رفض الطلب'),
                                      ),
                                    );
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              side: const BorderSide(color: kBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'رفض',
                              style: _text(17, FontWeight.w800, kNavy),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: seconds > 0
                                ? () {
                                    timer?.cancel();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم قبول الطلب'),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: const Color(0xFF1F9D63),
                              disabledBackgroundColor: Colors.grey.shade300,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'قبول',
                              style: _text(
                                17,
                                FontWeight.w800,
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
            else
              Container(
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
                      child: const Icon(
                        Icons.access_time,
                        color: kGrey,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'مفيش طلبات دلوقتي',
                      style: _text(22, FontWeight.w800, kNavy),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ارجع متصل عشان تستقبل طلبات.',
                      style: _text(14, FontWeight.w500, kGrey),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // الشغل القادم
<<<<<<< HEAD
            _currentJob(),
=======
            Container(
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
                          'التالي: غسالة',
                          style: _text(17, FontWeight.w800, kNavy),
                        ),
                        Text(
                          'النهاردة، 8:30 م · مصر الجديدة',
                          style: _text(12, FontWeight.w500, kGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
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

        // التنقل بين الصفحات الأربع
<<<<<<< HEAD
        body: IndexedStack(index: tabIndex, children: pages),
=======
        body: IndexedStack(
          index: tabIndex,
          children: pages,
        ),
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

        // الشريط السفلي الثابت
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabIndex,
          onTap: (index) {
            setState(() => tabIndex = index);
          },
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
<<<<<<< HEAD
=======

>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
