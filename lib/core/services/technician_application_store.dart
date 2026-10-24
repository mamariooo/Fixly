import 'package:flutter/foundation.dart';

enum ApplicationStatus { pending, approved, rejected }

class TechnicianApplication {
  TechnicianApplication({
    required this.id,
    required this.name,
    required this.phone,
    required this.skill,
    required this.years,
    required this.area,
    required this.idPhoto,
    required this.createdAt,
    this.status = ApplicationStatus.pending,
  });

  final String id;
  final String name;
  final String phone;
  final String skill;
  final String years;
  final String area;
  final String idPhoto;
  final DateTime createdAt;
  ApplicationStatus status;
}

/// طلبات انضمام الفنيين (في الذاكرة).
/// التسجيل بيضيف طلب، والأدمن بيوافق أو يرفض.
class TechnicianApplicationStore extends ChangeNotifier {
  TechnicianApplicationStore._();
  static final TechnicianApplicationStore instance =
      TechnicianApplicationStore._();

  final List<TechnicianApplication> _items = [];
  int _counter = 0;

  /// بيوحّد شكل الرقم: +20 101 234 5678 / 0101... / 101... كلهم نفس الرقم
  static String normalizePhone(String raw) {
    var d = raw.replaceAll(RegExp(r'[\s\-+]'), '');
    if (d.startsWith('20') && d.length > 10) d = d.substring(2);
    if (d.startsWith('0')) d = d.substring(1);
    return d;
  }

  List<TechnicianApplication> get all => _items.reversed.toList();

  int countOf(ApplicationStatus s) =>
      _items.where((a) => a.status == s).length;

  TechnicianApplication submit({
    required String name,
    required String phone,
    required String skill,
    required String years,
    required String area,
    required String idPhoto,
  }) {
    final a = TechnicianApplication(
      id: 'T${++_counter}',
      name: name,
      phone: phone,
      skill: skill,
      years: years,
      area: area,
      idPhoto: idPhoto,
      createdAt: DateTime.now(),
    );
    _items.add(a);
    notifyListeners();
    return a;
  }

  void setStatus(TechnicianApplication a, ApplicationStatus s) {
    a.status = s;
    notifyListeners();
  }

  /// آخر طلب بنفس رقم التليفون (لو موجود)
  TechnicianApplication? findByPhone(String raw) {
    final target = normalizePhone(raw);
    for (final a in _items.reversed) {
      if (normalizePhone(a.phone) == target) return a;
    }
    return null;
  }
}