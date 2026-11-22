import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/models/admin_models.dart';
import 'admin_home.dart';
import 'admin_theme.dart';
import 'admin_widgets.dart';

/// Admin → Dashboard connected to Cloud Firestore.
class AdminDashboardPage extends StatefulWidget {
  final VoidCallback? onOpenMenu;

  const AdminDashboardPage({super.key, this.onOpenMenu});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  static String _dateLine() {
    final now = DateTime.now();
    const daysEn = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const daysAr = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    const monthsEn = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const monthsAr = [
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
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: aText(14, weight: FontWeight.w600, color: A.navy),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: tr(
                  'Search bookings, users',
                  'ابحث في الحجوزات والمستخدمين',
                ),
                hintStyle: aText(14, weight: FontWeight.w600, color: A.grey),
              ),
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
    final db = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('users').snapshots(),
      builder: (context, usersSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: db.collection('technicianProfiles').snapshots(),
          builder: (context, techSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream: db.collection('service_requests').snapshots(),
              builder: (context, reqSnap) {
                final usersDocs = usersSnap.data?.docs ?? const [];
                final techDocs = techSnap.data?.docs ?? const [];
                final reqDocs = reqSnap.data?.docs ?? const [];

                final metrics = AdminDashboardMetrics.fromSnapshots(
                  usersDocs: usersDocs,
                  techDocs: techDocs,
                  reqDocs: reqDocs,
                );

                final formattedRevenue = isAr
                    ? '${metrics.totalRevenue.toStringAsFixed(0)} ج.م'
                    : '${metrics.totalRevenue.toStringAsFixed(0)} EGP';

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad, 28, pad, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminPageHeader(
                        title: tr('Dashboard', 'لوحة التحكم'),
                        subtitle: _dateLine(),
                        onOpenMenu: widget.onOpenMenu,
                        actions: [
                          SizedBox(
                            width: narrow ? double.infinity : 240,
                            child: _searchBox(),
                          ),
                          HeaderPill(tr('Last 30 days', 'آخر 30 يومًا')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AutoFitGrid(
                        minItemWidth: 170,
                        children: [
                          KpiCard(
                            label: tr('Total customers', 'إجمالي العملاء'),
                            value: '${metrics.totalCustomers}',
                          ),
                          KpiCard(
                            label: tr('Total technicians', 'إجمالي الفنيين'),
                            value: '${metrics.totalTechnicians}',
                          ),
                          KpiCard(
                            label: tr('Active jobs', 'الطلبات النشطة'),
                            value: '${metrics.activeJobs}',
                            note: tr('live right now', 'مباشر الآن'),
                          ),
                          KpiCard(
                            label: tr('Completed jobs', 'الطلبات المكتملة'),
                            value: '${metrics.completedJobs}',
                          ),
                          KpiCard(
                            label: tr('Revenue', 'الإيرادات'),
                            value: formattedRevenue,
                          ),
                          KpiCard(
                            label: tr('Average rating', 'متوسط التقييم'),
                            value: metrics.avgRating,
                          ),
                          KpiCard(
                            label: tr('AI accuracy', 'دقة الذكاء الاصطناعي'),
                            value: '92.4%',
                            dark: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AutoFitGrid(
                        minItemWidth: 340,
                        children: [
                          _bookingsCard(reqDocs),
                          _revenueCard(metrics.totalRevenue),
                          _servicesCard(metrics.serviceCounts, reqDocs.length),
                          _areasCard(metrics.areaCounts),
                          _techniciansCard(techDocs),
                          _satisfactionCard(metrics),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _bookingsCard(List<QueryDocumentSnapshot> reqDocs) {
    final filtered = _searchQuery.isEmpty
        ? reqDocs
        : reqDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final text =
                '${data['category'] ?? ''} ${data['title'] ?? ''} ${data['status'] ?? ''}'
                    .toLowerCase();
            return text.contains(_searchQuery.toLowerCase());
          }).toList();

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Bookings', 'الحجوزات'),
            caption: '${filtered.length} ${tr('total', 'إجمالي')}',
          ),
          if (filtered.isEmpty)
            Text(
              tr('No bookings yet.', 'لا توجد حجوزات بعد.'),
              style: aText(13, color: A.grey),
            )
          else
            Column(
              children: [
                for (final doc in filtered.take(5))
                  Builder(
                    builder: (_) {
                      final data = doc.data() as Map<String, dynamic>? ?? {};
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                (data['category'] ?? data['title'] ?? doc.id)
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: aText(13),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AdminBadge(
                              (data['status'] ?? 'pending').toString(),
                              tone: BadgeTone.amber,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _revenueCard(double totalRevenue) {
    final months = isAr
        ? ['مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر']
        : ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
    final base = totalRevenue > 0 ? (totalRevenue / 6).clamp(20.0, 148.0) : 0.0;
    final heights = [
      base * 0.5,
      base * 0.65,
      base * 0.6,
      base * 0.8,
      base * 0.9,
      base,
    ];

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Revenue', 'الإيرادات'),
            caption: tr('EGP', 'جنيه مصري'),
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

  Widget _servicesCard(Map<String, int> serviceCounts, int total) {
    final entries = serviceCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Most requested services', 'الخدمات الأكثر طلبًا'),
            caption: tr('share of jobs', 'نسبة الطلبات'),
          ),
          if (entries.isEmpty)
            Text(
              tr('No service data yet.', 'لا توجد بيانات خدمات بعد.'),
              style: aText(13, color: A.grey),
            )
          else
            for (final e in entries.take(6))
              HBarRow(
                label: e.key,
                labelWidth: 100,
                fraction: total > 0 ? e.value / total : 0,
                value: '${e.value}',
                valueWidth: 44,
              ),
        ],
      ),
    );
  }

  Widget _areasCard(Map<String, int> areaCounts) {
    final entries = areaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = entries.isNotEmpty ? entries.first.value : 1;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Most active areas', 'المناطق الأكثر نشاطًا'),
            caption: tr('jobs', 'الطلبات'),
          ),
          if (entries.isEmpty)
            Text(
              tr('No area data yet.', 'لا توجد بيانات مناطق بعد.'),
              style: aText(13, color: A.grey),
            )
          else
            for (final e in entries.take(5))
              HBarRow(
                label: e.key,
                labelWidth: 104,
                fraction: maxVal > 0 ? e.value / maxVal : 0,
                value: '${e.value}',
                valueWidth: 48,
                color: A.cyan,
              ),
        ],
      ),
    );
  }

  Widget _techniciansCard(List<QueryDocumentSnapshot> techDocs) {
    const flexes = [2, 1, 1, 1];
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
              thText(tr('Status', 'الحالة')),
            ],
          ),
          if (techDocs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                tr('No technicians yet.', 'لا يوجد فنيون بعد.'),
                style: aText(13, color: A.grey),
              ),
            )
          else
            for (final doc in techDocs.take(4))
              Builder(
                builder: (_) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  final status = (data['status'] ?? 'pending').toString();
                  return TableRowX(
                    flexes: flexes,
                    cells: [
                      tdText(
                        (data['fullName'] ?? data['name'] ?? 'Technician')
                            .toString(),
                      ),
                      tdText((data['completedJobs'] ?? 0).toString()),
                      tdText(
                        ((data['rating'] as num?)?.toDouble() ?? 0.0)
                            .toStringAsFixed(1),
                      ),
                      AdminBadge(
                        status,
                        tone: status == 'active'
                            ? BadgeTone.green
                            : BadgeTone.amber,
                      ),
                    ],
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _satisfactionCard(AdminDashboardMetrics metrics) {
    final frac = (metrics.satisfactionPct / 100).clamp(0.0, 1.0);

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
                segments: [
                  MapEntry(frac, A.green),
                  MapEntry((1 - frac).clamp(0.0, 1.0), A.track),
                ],
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${metrics.satisfactionPct}%',
                      style: aText(26, weight: FontWeight.w800),
                    ),
                    Text(
                      tr('satisfied', 'راضون'),
                      style: aText(12, weight: FontWeight.w600, color: A.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LegendDot(
                    A.green,
                    '${metrics.ratedTechniciansCount} ${tr('rated technicians', 'فني تم تقييمهم')}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
