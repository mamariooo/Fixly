import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/models/booking.dart';
import '../core/services/booking_store.dart';
import '../core/theme/app_colors.dart';
import '../main.dart';
import 'ai_chat_screen.dart';

const Color _iconBg = Color(0xFFDCE9FF);
const Color _emptyIconBg = Color(0xFFF0F3F8);
const Color _greenBg = Color(0xFFDDF3E6);
const Color _greenText = Color(0xFF14733A);
const Color _amberBg = Color(0xFFFDEBC8);
const Color _amberText = Color(0xFF8A5300);
const Color _blueBg = Color(0xFFDCE9FF);
const Color _blueText = Color(0xFF1B4FA8);
const Color _redBg = Color(0xFFFDE2E1);
const Color _redText = Color(0xFFB42318);

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  static const List<String> _monthsEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _monthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  String _date(DateTime d, bool isAr) {
    final m = isAr ? _monthsAr[d.month - 1] : _monthsEn[d.month - 1];
    return '${d.day} $m';
  }

  (Color, Color) _statusColors(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
        return (_amberBg, _amberText);
      case BookingStatus.accepted:
      case BookingStatus.onTheWay:
      case BookingStatus.inProgress:
        return (_blueBg, _blueText);
      case BookingStatus.completed:
        return (_greenBg, _greenText);
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return (_redBg, _redText);
    }
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: kGrey,
      ),
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: kBorder.withValues(alpha: 0.7)),
  );

  Widget _emptyActiveCard(BuildContext context, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: _emptyIconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: kGrey,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isAr ? 'لا توجد طلبات جارية حالياً' : 'No active booking yet',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isAr
                ? 'اشرح مشكلتك وسيساعدك الذكاء الاصطناعي في ترشيح أفضل فني.'
                : 'Describe a problem and Fixly AI will find the best technician.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiChatScreen()),
                );
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
                isAr ? 'طلب صيانة جديدة عبر AI' : 'Find a Technician',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingCard(BuildContext context, Booking b, bool isAr) {
    final (bg, fg) = _statusColors(b.status);
    final priceText = b.price == null
        ? ''
        : ' · ${b.price} ${isAr ? 'ج.م' : 'EGP'}';

    return InkWell(
      onTap: () => _openDetails(context, b),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(b.icon, color: kBlue, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.issue,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${b.service} · ${_date(b.createdAt, isAr)}$priceText',
                        style: GoogleFonts.manrope(fontSize: 13, color: kGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isAr ? b.status.labelAr : b.status.label,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),

            // لو الفني قبل وحدد السعر والعميل لسه ما اختارش كاش ولا فيزا
            if (b.status == BookingStatus.accepted && b.price != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF16A34A),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAr
                            ? 'حدد الفني السعر: ${b.price} ج.م · اختر طريقة الدفع (كاش/فيزا)'
                            : 'Price quoted: ${b.price} EGP · Tap to select Cash or Visa',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, Booking b) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => ListenableBuilder(
        listenable: BookingStore.instance,
        builder: (_, _) => _detailsSheet(sheetContext, b),
      ),
    );
  }

  Widget _stepRow(String label, {required bool done, required bool current}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? kBlue : kBorder,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: current ? FontWeight.w800 : FontWeight.w600,
              color: done ? kNavy : kGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// حوار اختيار وسداد الدفع (كاش أو فيزا)
  void _showPaymentModal(BuildContext context, Booking b) {
    final isAr = appLocale.value.languageCode == 'ar';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'اختر طريقة الدفع' : 'Select Payment Method',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isAr
                    ? 'المبلغ المطلوب سداده للفني: ${b.price ?? 250} ج.م'
                    : 'Total amount to pay technician: ${b.price ?? 250} EGP',
                style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
              ),
              const SizedBox(height: 20),

              // خيار الكاش
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: b.paymentMethod == 'Cash'
                        ? const Color(0xFF1D5FD8)
                        : kBorder,
                    width: 1.5,
                  ),
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF3E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.money, color: Color(0xFF14733A)),
                ),
                title: Text(
                  isAr ? 'الدفع نقداً (كاش)' : 'Cash on Delivery',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                subtitle: Text(
                  isAr
                      ? 'سداد المبلغ للفني يداً بيد بعد الانتهاء'
                      : 'Pay directly to technician after work',
                  style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                ),
                trailing: b.paymentMethod == 'Cash'
                    ? const Icon(Icons.check_circle, color: Color(0xFF1D5FD8))
                    : null,
                onTap: () async {
                  await BookingStore.instance.setPaymentMethod(
                    b,
                    method: 'Cash',
                    isPaid: false,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isAr
                              ? 'تم تحديد طريقة الدفع: كاش'
                              : 'Payment set: Cash',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // خيار الفيزا
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: b.paymentMethod == 'Visa'
                        ? const Color(0xFF1D5FD8)
                        : kBorder,
                    width: 1.5,
                  ),
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Color(0xFF1B4FA8),
                  ),
                ),
                title: Text(
                  isAr ? 'بطاقة بنكية / فيزا' : 'Visa / Credit Card',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                subtitle: Text(
                  isAr
                      ? 'دفع إلكتروني آمن ومباشر'
                      : 'Secure instant card payment',
                  style: GoogleFonts.manrope(fontSize: 12, color: kGrey),
                ),
                trailing: b.paymentMethod == 'Visa' && b.paymentStatus == 'paid'
                    ? const Icon(Icons.check_circle, color: Color(0xFF1F9D63))
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  _showVisaCardSheet(context, b);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVisaCardSheet(BuildContext context, Booking b) {
    final isAr = appLocale.value.languageCode == 'ar';
    final cardCtrl = TextEditingController(text: '4123 •••• •••• 9876');
    final expCtrl = TextEditingController(text: '12/28');
    final cvvCtrl = TextEditingController(text: '•••');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
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
              Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: Color(0xFF1D5FD8),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isAr
                        ? 'سداد بالفيزا / البطاقة البنكية'
                        : 'Pay with Visa / Card',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardCtrl,
                decoration: InputDecoration(
                  labelText: isAr ? 'رقم البطاقة' : 'Card Number',
                  prefixIcon: const Icon(Icons.payment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expCtrl,
                      decoration: InputDecoration(
                        labelText: isAr ? 'تاريخ الانتهاء' : 'Expiry',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: cvvCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await BookingStore.instance.setPaymentMethod(
                      b,
                      method: 'Visa',
                      isPaid: true,
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1F9D63),
                          content: Text(
                            isAr
                                ? 'تم سداد ${b.price ?? 250} ج.م بالفيزا بنجاح ✓'
                                : 'Successfully paid ${b.price ?? 250} EGP via Visa ✓',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F9D63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isAr
                        ? 'تأكيد السداد (${b.price ?? 250} ج.م)'
                        : 'Confirm Payment (${b.price ?? 250} EGP)',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsSheet(BuildContext context, Booking b) {
    final isAr = appLocale.value.languageCode == 'ar';
    final cancelled =
        b.status == BookingStatus.cancelled ||
        b.status == BookingStatus.rejected;
    final canCancel =
        b.status == BookingStatus.pending || b.status == BookingStatus.accepted;

    final steps = [
      (BookingStatus.pending, isAr ? 'تم إرسال الطلب للفني' : 'Request sent'),
      (
        BookingStatus.accepted,
        isAr ? 'قبل الفني وحدد السعر' : 'Technician accepted & quoted price',
      ),
      (BookingStatus.onTheWay, isAr ? 'الفني في الطريق إليك' : 'On the way'),
      (
        BookingStatus.inProgress,
        isAr ? 'جاري أعمال الصيانة' : 'Work in progress',
      ),
      (BookingStatus.completed, isAr ? 'تم الانتهاء بنجاح' : 'Completed'),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              b.issue,
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${b.service} · ${b.urgency} urgency',
              style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
            ),
            const SizedBox(height: 12),

            // الفني المكلف
            if (b.technicianName != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.handyman_outlined, color: kBlue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${isAr ? 'الفني المختار: ' : 'Technician: '}${b.technicianName}',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // كارت السعر وطريقة الدفع
            if (b.price != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr
                              ? 'السعر النهائي المحدد من الفني:'
                              : 'Final Quoted Price:',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF166534),
                          ),
                        ),
                        Text(
                          '${b.price} ${isAr ? 'ج.م' : 'EGP'}',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${isAr ? 'طريقة الدفع: ' : 'Payment: '}${b.paymentMethod ?? (isAr ? 'لم تحدد بعد' : 'Not chosen')}',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kNavy,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showPaymentModal(context, b),
                          child: Text(
                            isAr ? 'تغيير / سداد' : 'Change / Pay',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w800,
                              color: kBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ملخص AI
            if (b.aiSummary != null && b.aiSummary!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${isAr ? 'ملخص الذكاء الاصطناعي: ' : 'AI Summary: '}${b.aiSummary}',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF0E7490),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // الصور المرفقة
            if (b.photoUrls.isNotEmpty) ...[
              Text(
                isAr ? 'الصور المرفقة:' : 'Attached Photos:',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: b.photoUrls.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, idx) {
                    final p = b.photoUrls[idx];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: !kIsWeb && File(p).existsSync()
                          ? Image.file(
                              File(p),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              color: const Color(0xFFE5EAF1),
                              child: const Icon(Icons.image, color: kGrey),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
            ],

            // مراحل التتبع
            if (cancelled)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _redBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAr
                      ? 'هذا الطلب ملغي أو معتذر عنه'
                      : 'This booking was cancelled',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _redText,
                  ),
                ),
              )
            else
              ...steps.map(
                (s) => _stepRow(
                  s.$2,
                  done: b.status.index >= s.$1.index,
                  current: b.status == s.$1,
                ),
              ),
            const SizedBox(height: 16),

            if (canCancel)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    BookingStore.instance.cancel(b);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _redText,
                    side: const BorderSide(color: _redText),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isAr ? 'إلغاء الطلب' : 'Cancel booking',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            // التقييم بعد الانتهاء
            if (b.status == BookingStatus.completed && b.rating == null)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _rate(context, b),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isAr ? 'تقييم الفني' : 'Rate technician',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            if (b.status == BookingStatus.completed && b.rating != null)
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(
                      i < b.rating! ? Icons.star : Icons.star_border,
                      color: const Color(0xFFF5B301),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isAr ? 'شكراً لتقييمك!' : 'Thanks for rating!',
                    style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _rate(BuildContext context, Booking b) {
    int stars = 5;
    final isAr = appLocale.value.languageCode == 'ar';

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(isAr ? 'تقييم الفني' : 'Rate your technician'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => IconButton(
                icon: Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF5B301),
                  size: 32,
                ),
                onPressed: () => setLocal(() => stars = i + 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isAr ? 'لاحقاً' : 'Later'),
            ),
            TextButton(
              onPressed: () {
                BookingStore.instance.rate(b, stars);
                Navigator.pop(ctx);
              },
              child: Text(isAr ? 'إرسال' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = appLocale.value.languageCode == 'ar';

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: BookingStore.instance,
          builder: (context, _) {
            final active = BookingStore.instance.active;
            final past = BookingStore.instance.past;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'طلبات الصيانة' : 'Bookings',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAr
                        ? 'متابعة مراحل العمل والدفع وتحديد السعر مع الفني'
                        : 'Track work status, agreed price, and payments.',
                    style: GoogleFonts.manrope(fontSize: 14, color: kGrey),
                  ),
                  const SizedBox(height: 20),

                  _sectionLabel(isAr ? 'الطلبات الجارية' : 'ACTIVE BOOKINGS'),
                  if (active.isEmpty)
                    _emptyActiveCard(context, isAr)
                  else
                    ...active.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _bookingCard(context, b, isAr),
                      ),
                    ),

                  if (past.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionLabel(isAr ? 'الطلبات السابقة' : 'PAST BOOKINGS'),
                    ...past.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _bookingCard(context, b, isAr),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
