import 'package:flutter/material.dart';

import 'package:fixly/core/services/technician_application_store.dart';
import 'admin_home.dart';
import 'admin_theme.dart';
import 'admin_widgets.dart';

/// Admin → Technicians (مراجعة طلبات انضمام الفنيين: موافقة / رفض).
class AdminTechniciansPage extends StatefulWidget {
  final VoidCallback? onOpenMenu;

  const AdminTechniciansPage({super.key, this.onOpenMenu});

  @override
  State<AdminTechniciansPage> createState() => _AdminTechniciansPageState();
}

class _AdminTechniciansPageState extends State<AdminTechniciansPage> {
  ApplicationStatus? _filter; // null = الكل

  String _statusLabel(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.pending:
        return tr('Pending', 'قيد المراجعة');
      case ApplicationStatus.approved:
        return tr('Approved', 'تمت الموافقة');
      case ApplicationStatus.rejected:
        return tr('Rejected', 'مرفوض');
    }
  }

  BadgeTone _tone(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.pending:
        return BadgeTone.amber;
      case ApplicationStatus.approved:
        return BadgeTone.green;
      case ApplicationStatus.rejected:
        return BadgeTone.red;
    }
  }

  Widget _filterChip(String label, ApplicationStatus? value) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = value),
      labelStyle: aText(13, color: selected ? Colors.white : A.navy),
      selectedColor: A.navy,
      backgroundColor: Colors.white,
      side: const BorderSide(color: A.border),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: aText(13, color: A.grey)),
          ),
          Expanded(
            child: Text(value, style: aText(13, weight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _card(TechnicianApplication a) {
    final store = TechnicianApplicationStore.instance;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(a.name, style: aText(17, weight: FontWeight.w800)),
              ),
              AdminBadge(_statusLabel(a.status), tone: _tone(a.status)),
            ],
          ),
          const SizedBox(height: 10),
          _info(tr('Phone', 'التليفون'), a.phone),
          _info(tr('Skill', 'المهارة'), a.skill),
          _info(
            tr('Experience', 'الخبرة'),
            tr('${a.years} years', '${a.years} سنة'),
          ),
          _info(tr('Area', 'المنطقة'), a.area),
          _info(tr('ID photo', 'صورة الهوية'), a.idPhoto),
          if (a.status == ApplicationStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      store.setStatus(a, ApplicationStatus.rejected);
                      showAdminToast(
                        context,
                        tr('Application rejected', 'تم رفض الطلب'),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      foregroundColor: A.redText,
                      side: const BorderSide(color: A.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(tr('Reject', 'رفض')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      store.setStatus(a, ApplicationStatus.approved);
                      showAdminToast(
                        context,
                        tr('Technician approved', 'تمت الموافقة على الفني'),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: A.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(tr('Approve', 'موافقة')),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.of(context).size.width < 600;
    final pad = narrow ? 16.0 : 32.0;

    return ListenableBuilder(
      listenable: TechnicianApplicationStore.instance,
      builder: (context, _) {
        final store = TechnicianApplicationStore.instance;
        final all = store.all;
        final items = _filter == null
            ? all
            : all.where((a) => a.status == _filter).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pad, 28, pad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminPageHeader(
                title: tr('Technicians', 'الفنيون'),
                subtitle: tr(
                  'Review applications and approve new technicians',
                  'راجع الطلبات ووافق على الفنيين الجدد',
                ),
                onOpenMenu: widget.onOpenMenu,
              ),
              const SizedBox(height: 20),
              AutoFitGrid(
                minItemWidth: 170,
                children: [
                  KpiCard(
                    label: tr('Pending', 'قيد المراجعة'),
                    value: '${store.countOf(ApplicationStatus.pending)}',
                  ),
                  KpiCard(
                    label: tr('Approved', 'تمت الموافقة'),
                    value: '${store.countOf(ApplicationStatus.approved)}',
                  ),
                  KpiCard(
                    label: tr('Rejected', 'مرفوض'),
                    value: '${store.countOf(ApplicationStatus.rejected)}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _filterChip('${tr('All', 'الكل')} (${all.length})', null),
                  _filterChip(
                    tr('Pending', 'قيد المراجعة'),
                    ApplicationStatus.pending,
                  ),
                  _filterChip(
                    tr('Approved', 'تمت الموافقة'),
                    ApplicationStatus.approved,
                  ),
                  _filterChip(
                    tr('Rejected', 'مرفوض'),
                    ApplicationStatus.rejected,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                AdminCard(
                  child: Text(
                    tr('No applications here yet.', 'مفيش طلبات هنا لسه.'),
                    style: aText(14, color: A.grey),
                  ),
                )
              else
                AutoFitGrid(
                  minItemWidth: 340,
                  children: [for (final a in items) _card(a)],
                ),
            ],
          ),
        );
      },
    );
  }
}
