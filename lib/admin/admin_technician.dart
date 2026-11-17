import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/models/admin_models.dart';
import '../core/models/app_user.dart';
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
  AdminAppFilterStatus? _filter; // null = الكل
  final Set<String> _processingIds = {};

  String _statusLabel(AdminAppFilterStatus s) {
    switch (s) {
      case AdminAppFilterStatus.pending:
        return tr('Pending', 'قيد المراجعة');
      case AdminAppFilterStatus.approved:
        return tr('Approved', 'تمت الموافقة');
      case AdminAppFilterStatus.rejected:
        return tr('Rejected', 'مرفوض');
    }
  }

  BadgeTone _tone(AdminAppFilterStatus s) {
    switch (s) {
      case AdminAppFilterStatus.pending:
        return BadgeTone.amber;
      case AdminAppFilterStatus.approved:
        return BadgeTone.green;
      case AdminAppFilterStatus.rejected:
        return BadgeTone.red;
    }
  }

  Future<void> _updateApplicationStatus({
    required AdminTechApplication item,
    required bool approve,
  }) async {
    if (_processingIds.contains(item.docId)) return;
    setState(() => _processingIds.add(item.docId));

    try {
      final db = FirebaseFirestore.instance;
      final appRef = db.collection('technicianApplications').doc(item.docId);
      final userRef = db.collection('users').doc(item.docId);
      final profileRef = db.collection('technicianProfiles').doc(item.docId);

      final batch = db.batch();

      if (approve) {
        batch.set(appRef, {
          'status': 'approved',
          'reviewedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        batch.set(userRef, {
          'role': UserRole.technician.toJson(),
          'isTechnician': true,
          'accountStatus': AccountStatus.active.toFirestore(),
          'activeRole': UserRole.technician.toJson(),
          'technicianSpecialty': item.skill,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        batch.set(profileRef, {
          'name': item.name,
          'fullName': item.name,
          'phone': item.phone,
          'specialty': item.skill,
          'area': item.area,
          'status': 'active',
          'isAvailable': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        batch.set(appRef, {
          'status': 'rejected',
          'reviewedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        batch.set(userRef, {
          'accountStatus': AccountStatus.rejected.toFirestore(),
          'activeRole': UserRole.client.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        batch.set(profileRef, {
          'status': 'rejected',
          'isAvailable': false,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();

      if (!mounted) return;
      showAdminToast(
        context,
        approve
            ? tr('Technician approved', 'تمت الموافقة على الفني')
            : tr('Application rejected', 'تم رفض الطلب'),
      );
    } catch (e) {
      if (!mounted) return;
      showAdminToast(
        context,
        tr('Failed to update status: $e', 'حدث خطأ أثناء التحديث: $e'),
      );
    } finally {
      if (mounted) {
        setState(() => _processingIds.remove(item.docId));
      }
    }
  }

  Widget _filterChip(String label, AdminAppFilterStatus? value) {
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

  Widget _card(AdminTechApplication a) {
    final isBusy = _processingIds.contains(a.docId);

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
          if (a.status == AdminAppFilterStatus.pending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isBusy
                        ? null
                        : () =>
                              _updateApplicationStatus(item: a, approve: false),
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
                    onPressed: isBusy
                        ? null
                        : () =>
                              _updateApplicationStatus(item: a, approve: true),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: A.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(tr('Approve', 'موافقة')),
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

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('technicianApplications')
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const [];
        final all = docs.map(AdminTechApplication.fromDoc).toList();

        final pendingCount = all
            .where((a) => a.status == AdminAppFilterStatus.pending)
            .length;
        final approvedCount = all
            .where((a) => a.status == AdminAppFilterStatus.approved)
            .length;
        final rejectedCount = all
            .where((a) => a.status == AdminAppFilterStatus.rejected)
            .length;

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
                    value: '$pendingCount',
                  ),
                  KpiCard(
                    label: tr('Approved', 'تمت الموافقة'),
                    value: '$approvedCount',
                  ),
                  KpiCard(
                    label: tr('Rejected', 'مرفوض'),
                    value: '$rejectedCount',
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
                    AdminAppFilterStatus.pending,
                  ),
                  _filterChip(
                    tr('Approved', 'تمت الموافقة'),
                    AdminAppFilterStatus.approved,
                  ),
                  _filterChip(
                    tr('Rejected', 'مرفوض'),
                    AdminAppFilterStatus.rejected,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snapshot.hasError)
                AdminCard(
                  child: Text(
                    tr(
                      'Error loading applications: ${snapshot.error}',
                      'خطأ في تحميل الطلبات: ${snapshot.error}',
                    ),
                    style: aText(14, color: A.redText),
                  ),
                )
              else if (items.isEmpty)
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
