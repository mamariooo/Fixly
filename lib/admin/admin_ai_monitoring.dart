import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'admin_theme.dart';
import 'admin_widgets.dart';

/// Admin → AI Monitoring (diagnosis, vision, emergency detection, matching).
class AdminAiMonitoringPage extends StatelessWidget {
  final VoidCallback? onOpenMenu;

  const AdminAiMonitoringPage({super.key, this.onOpenMenu});

  Widget _gaugeCard({
    required double fraction,
    required Color color,
    required String value,
    required String title,
    required String delta,
  }) {
    return AdminCard(
      child: Row(
        children: [
          RingGauge(fraction: fraction, color: color, label: value),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: aText(13, color: A.grey)),
                const SizedBox(height: 2),
                Text(delta,
                    style: aText(12, weight: FontWeight.w800, color: A.greenText)),
              ],
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
            title: tr('AI Monitoring', 'مراقبة الذكاء الاصطناعي'),
            subtitle: tr(
              'Diagnosis, vision, emergency detection and matching quality',
              'التشخيص والرؤية واكتشاف الطوارئ وجودة المطابقة',
            ),
            onOpenMenu: onOpenMenu,
            actions: [
              AdminBadge(
                tr('All models healthy', 'جميع النماذج تعمل بكفاءة'),
                tone: BadgeTone.green,
                height: 32,
                fontSize: 13,
              ),
              HeaderPill(tr('Last 30 days', 'آخر 30 يومًا')),
            ],
          ),
          const SizedBox(height: 20),

          // ───── Gauges ─────
          AutoFitGrid(
            minItemWidth: 220,
            children: [
              _gaugeCard(
                fraction: 197 / 214,
                color: A.blue,
                value: '92.4%',
                title: tr('AI Diagnosis Accuracy', 'دقة تشخيص الذكاء الاصطناعي'),
                delta: tr('+1.3% vs last month', '+1.3% عن الشهر الماضي'),
              ),
              _gaugeCard(
                fraction: 190 / 214,
                color: A.cyan,
                value: '89%',
                title: tr('Image Analysis Accuracy', 'دقة تحليل الصور'),
                delta: tr('+2.0% vs last month', '+2.0% عن الشهر الماضي'),
              ),
              _gaugeCard(
                fraction: 205 / 214,
                color: A.red,
                value: '96%',
                title: tr('Emergency Detection', 'اكتشاف الطوارئ'),
                delta: tr('0 missed this week', '0 حالات فائتة هذا الأسبوع'),
              ),
              _gaugeCard(
                fraction: 194 / 214,
                color: A.green,
                value: '91%',
                title: tr('Technician Matching Success', 'نجاح مطابقة الفنيين'),
                delta: tr('+0.8% vs last month', '+0.8% عن الشهر الماضي'),
              ),
              _gaugeCard(
                fraction: 188 / 214,
                color: A.navy,
                value: '88%',
                title: tr('Average AI Confidence', 'متوسط ثقة الذكاء الاصطناعي'),
                delta: tr('Stable', 'مستقر'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          AutoFitGrid(
            minItemWidth: 340,
            children: [
              _accuracyOverTime(),
              _confidenceDistribution(),
              _accuracyByService(),
              _needsReview(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accuracyOverTime() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Accuracy over time', 'الدقة عبر الزمن'),
            caption: tr('weekly', 'أسبوعيًا'),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                const LineChart(
                  height: 150,
                  gridY: [140, 100, 60],
                  series: [
                    LineSeries([
                      Offset(10, 110), Offset(60, 96), Offset(110, 100),
                      Offset(160, 80), Offset(210, 84), Offset(260, 62),
                      Offset(310, 66), Offset(390, 46),
                    ], A.blue),
                    LineSeries([
                      Offset(10, 130), Offset(60, 120), Offset(110, 124),
                      Offset(160, 106), Offset(210, 108), Offset(260, 92),
                      Offset(310, 90), Offset(390, 78),
                    ], A.cyan, dashed: true),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('Wk 1', 'أسبوع 1'), style: aText(11, color: A.grey)),
                    Text(tr('Wk 8', 'أسبوع 8'), style: aText(11, color: A.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              LegendDot(A.blue, tr('Diagnosis', 'التشخيص'), line: true),
              LegendDot(A.cyan, tr('Image analysis', 'تحليل الصور'), line: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _confidenceDistribution() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Confidence distribution', 'توزيع الثقة'),
            caption: tr('share of diagnoses', 'نسبة التشخيصات'),
          ),
          const BarColumns(
            height: 180,
            radius: 6,
            bars: [
              BarColumn('<50', 12, A.redBar),
              BarColumn('50–60', 26, A.amberBar),
              BarColumn('60–70', 44, A.amberBar),
              BarColumn('70–80', 72, A.blueSoft),
              BarColumn('80–90', 120, A.blue),
              BarColumn('90+', 150, A.navy, emphasized: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accuracyByService() {
    final rows = <List<Object>>[
      [tr('Electrical', 'كهرباء'), 0.95, '95%'],
      [tr('Plumbing', 'سباكة'), 0.93, '93%'],
      [tr('AC', 'تكييف'), 0.92, '92%'],
      [tr('Appliances', 'أجهزة منزلية'), 0.88, '88%'],
      [tr('Carpentry', 'نجارة'), 0.86, '86%'],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(tr('Accuracy by service', 'الدقة حسب الخدمة')),
          for (final r in rows)
            HBarRow(
              label: r[0] as String,
              labelWidth: 92,
              fraction: r[1] as double,
              value: r[2] as String,
            ),
        ],
      ),
    );
  }

  Widget _needsReview() {
    const flexes = [12, 20, 8, 8];
    final rows = <List<Object>>[
      ['FX-48102', tr('Plumbing · leak', 'سباكة · تسريب'), '58%', tr('Fixed', 'تم التصحيح'), BadgeTone.amber],
      ['FX-48077', tr('Carpentry · door', 'نجارة · باب'), '61%', tr('Fixed', 'تم التصحيح'), BadgeTone.amber],
      ['FX-48031', tr('Appliance · fridge', 'أجهزة · ثلاجة'), '54%', tr('Wrong', 'خاطئ'), BadgeTone.red],
      ['FX-47990', tr('AC · cooling', 'تكييف · تبريد'), '64%', tr('Correct', 'صحيح'), BadgeTone.green],
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            tr('Needs review', 'تحتاج مراجعة'),
            caption: tr('low confidence or corrected', 'ثقة منخفضة أو تم تصحيحها'),
          ),
          TableRowX(
            header: true,
            flexes: flexes,
            cells: [
              thText(tr('Case', 'الحالة')),
              thText(tr('AI said', 'قال الذكاء')),
              thText(tr('Conf.', 'الثقة')),
              thText(tr('Result', 'النتيجة')),
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
}
