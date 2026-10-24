import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'admin_theme.dart';
import 'admin_widgets.dart';

/// Admin → Dashboard (KPIs, bookings, revenue, services, areas, technicians,
/// customer satisfaction).
class AdminDashboardPage extends StatelessWidget {
  final VoidCallback? onOpenMenu;

  const AdminDashboardPage({super.key, this.onOpenMenu});

  static String _dateLine() {
    final now = DateTime.now();
    const daysEn = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    const daysAr = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    const monthsEn = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    const monthsAr = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو',
      'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final d = now.weekday - 1;
    final m = now.month - 1;
    return isAr
        ? '${daysAr[d]}، ${now.day} ${monthsAr[m]} ${now.year} · القاهرة'
        : '${daysEn[d]}, ${now.day} ${monthsEn[m]} ${now.year} · Cairo';
  }

  Widget _searchBox() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: A.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 18, color: A.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tr('Search bookings, users', 'ابحث في الحجوزات والمستخدمين'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: aText(14, weight: FontWeight.w600, color: A.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.of(context).size.width < 600;
    final pad = narrow ? 16.0 : 32.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(pad, 28, pad, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminPageHeader(
            title: tr('Dashboard', 'لوحة التحكم'),
            subtitle: _dateLine(),
            onOpenMenu: onOpenMenu,
            actions: [
              LayoutBuilder(
                builder: (context, _) {
                  // Fixed width so it sits nicely in both Row and Wrap.
                  return SizedBox(
                    width: narrow ? double.infinity : 240,
                    child: _searchBox(),
                  );
                },
              ),
              HeaderPill(tr('Last 30 days', 'آخر 30 يومًا')),
            ],
          ),
          const SizedBox(height: 20),

          // ───── KPIs ─────
          AutoFitGrid(
            minItemWidth: 170,
            children: [
              KpiCard(
                label: tr('Total customers', 'إجمالي العملاء'),
                value: '12,480',
                delta: '+8.2%',
              ),
              KpiCard(
                label: tr('Total technicians', 'إجمالي الفنيين'),
                value: '1,126',
                delta: '+3.1%',
              ),
              KpiCard(
                label: tr('Active jobs', 'الطلبات النشطة'),
                value: '214',
                note: tr('live right now', 'مباشر الآن'),
              ),
              KpiCard(
                label: tr('Completed jobs', 'الطلبات المكتملة'),
                value: '38,940',
                delta: '+11.4%',
              ),
              KpiCard(
                label: tr('Revenue', 'الإيرادات'),
                value: tr('1.42M EGP', '1.42 مليون ج.م'),
                delta: '+14.6%',
              ),
              KpiCard(
                label: tr('Average rating', 'متوسط التقييم'),
                value: '4.7',
                delta: '+0.1',
              ),
              KpiCard(
                label: tr('AI accuracy', 'دقة الذكاء الاصطناعي'),
                value: '92.4%',
                delta: '+1.3%',
                dark: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ───── Charts / lists ─────
          AutoFitGrid(
            minItemWidth: 340,
            children: [
              _bookingsCard(),
              _revenueCard(),
              _servicesCard(),
              _areasCard(),
              _techniciansCard(),
              _satisfactionCard(),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────────────── cards ─────────────────────────

  Widget _bookingsCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(tr('Bookings', 'الحجوزات'), caption: tr('per day', 'يوميًا')),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                const LineChart(
                  height: 150,
                  gridY: [130, 90, 50],
                  series: [
                    LineSeries(
                      [
                        Offset(10, 120), Offset(50, 104), Offset(90, 112),
                        Offset(130, 78), Offset(170, 90), Offset(210, 62),
                        Offset(250, 70), Offset(290, 44), Offset(330, 54),
                        Offset(390, 24),
                      ],
                      A.blue,
                      fill: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('1 Oct', '1 أكتوبر'), style: aText(11, color: A.grey)),
                    Text(tr('15 Oct', '15 أكتوبر'), style: aText(11, color: A.grey)),
                    Text(tr('30 Oct', '30 أكتوبر'), style: aText(11, color: A.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _revenueCard() {
    final months = isAr
        ? ['مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر']
        : ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
    const heights = [70.0, 92.0, 84.0, 112.0, 128.0, 148.0];

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Revenue', 'الإيرادات'),
            caption: tr('EGP thousands', 'بآلاف الجنيهات'),
          ),
          BarColumns(
            height: 170,
            bars: [
              for (var i = 0; i < 6; i++)
                BarColumn(
                  months[i],
                  heights[i],
                  i == 5 ? A.navy : A.blueSoft,
                  emphasized: i == 5,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _servicesCard() {
    final rows = <List<Object>>[
      [tr('AC', 'تكييف'), 0.92, '28%'],
      [tr('Plumbing', 'سباكة'), 0.78, '23%'],
      [tr('Electrical', 'كهرباء'), 0.66, '19%'],
      [tr('Appliances', 'أجهزة منزلية'), 0.42, '12%'],
      [tr('Cleaning', 'تنظيف'), 0.30, '9%'],
      [tr('Other', 'أخرى'), 0.30, '9%'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Most requested services', 'الخدمات الأكثر طلبًا'),
            caption: tr('share of jobs', 'نسبة الطلبات'),
          ),
          for (final r in rows)
            HBarRow(
              label: r[0] as String,
              labelWidth: 92,
              fraction: r[1] as double,
              value: r[2] as String,
              valueWidth: 44,
            ),
        ],
      ),
    );
  }

  Widget _areasCard() {
    final rows = <List<Object>>[
      [tr('Nasr City', 'مدينة نصر'), 0.94, '3,120'],
      [tr('Maadi', 'المعادي'), 0.76, '2,540'],
      [tr('Heliopolis', 'مصر الجديدة'), 0.64, '2,110'],
      [tr('New Cairo', 'القاهرة الجديدة'), 0.58, '1,930'],
      [tr('Giza', 'الجيزة'), 0.44, '1,460'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Most active areas', 'المناطق الأكثر نشاطًا'),
            caption: tr('jobs this month', 'طلبات هذا الشهر'),
          ),
          for (final r in rows)
            HBarRow(
              label: r[0] as String,
              labelWidth: 104,
              fraction: r[1] as double,
              value: r[2] as String,
              valueWidth: 48,
              color: A.cyan,
            ),
        ],
      ),
    );
  }

  Widget _techniciansCard() {
    const flexes = [2, 1, 1, 1];
    final rows = <List<Object>>[
      [tr('Ahmed Hassan', 'أحمد حسن'), '96', '4.8', '97%', BadgeTone.green],
      [tr('Mahmoud Saber', 'محمود صابر'), '88', '4.9', '95%', BadgeTone.green],
      [tr('Youssef Nabil', 'يوسف نبيل'), '81', '4.7', '92%', BadgeTone.green],
      [tr('Karim Adel', 'كريم عادل'), '64', '4.5', '81%', BadgeTone.amber],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Technician performance', 'أداء الفنيين'),
            caption: tr('top 4', 'أفضل 4'),
          ),
          TableRowX(
            header: true,
            flexes: flexes,
            cells: [
              thText(tr('Technician', 'الفني')),
              thText(tr('Jobs', 'الطلبات')),
              thText(tr('Rating', 'التقييم')),
              thText(tr('On time', 'في الموعد')),
            ],
          ),
          for (final r in rows)
            TableRowX(
              flexes: flexes,
              cells: [
                tdText(r[0] as String),
                tdText(r[1] as String),
                tdText(r[2] as String),
                AdminBadge(r[3] as String, tone: r[4] as BadgeTone),
              ],
            ),
        ],
      ),
    );
  }

  Widget _satisfactionCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(tr('Customer satisfaction', 'رضا العملاء')),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DonutChart(
                segments: const [
                  MapEntry(289 / 352, A.green),
                  MapEntry(42 / 352, A.amber),
                ],
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('94%', style: aText(26, weight: FontWeight.w800)),
                    Text(tr('satisfied', 'راضون'),
                        style: aText(12, weight: FontWeight.w600, color: A.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LegendDot(A.green, tr('4–5 stars · 82%', '4–5 نجوم · 82%')),
                  const SizedBox(height: 8),
                  LegendDot(A.amber, tr('3 stars · 12%', '3 نجوم · 12%')),
                  const SizedBox(height: 8),
                  LegendDot(A.track, tr('1–2 stars · 6%', '1–2 نجوم · 6%')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
