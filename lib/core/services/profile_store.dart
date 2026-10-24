import 'package:flutter/foundation.dart';

class SavedAddress {
  SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    this.isDefault = false,
  });

  final String id;
  String label;
  String address;
  bool isDefault;
}

class PaymentMethod {
  PaymentMethod({
    required this.id,
    required this.title,
    required this.isCard,
    this.last4,
    this.isDefault = false,
  });

  final String id;
  final String title;
  final bool isCard;
  final String? last4; // آخر 4 أرقام بس. مش بنخزن رقم الكارت كامل
  bool isDefault;
  String get label => isCard ? '$title •••• $last4' : title;
}

class TechnicianInfo {
  const TechnicianInfo(this.name, this.skill, this.rating);

  final String name;
  final String skill;
  final double rating;
}

/// بيانات البروفايل في الذاكرة (العناوين، طرق الدفع، المفضلة).
/// لما نربط Firebase هنبدّل جواه بس.
class ProfileStore extends ChangeNotifier {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  static const List<TechnicianInfo> technicians = [
    TechnicianInfo('Hossam Ali', 'Plumbing', 4.8),
    TechnicianInfo('Mona Adel', 'Air Conditioning', 4.9),
    TechnicianInfo('Omar Khaled', 'Electrical', 4.7),
    TechnicianInfo('Sara Mahmoud', 'Cleaning', 4.6),
  ];

  final List<SavedAddress> _addresses = [];
  final List<PaymentMethod> _payments = [
    PaymentMethod(id: 'cash', title: 'Cash', isCard: false, isDefault: true),
  ];
  final Set<String> _favorites = {};
  int _counter = 0;

  // ---------- العناوين ----------
  List<SavedAddress> get addresses => List.unmodifiable(_addresses);

  void addAddress(String label, String address) {
    _addresses.add(SavedAddress(
      id: 'A${++_counter}',
      label: label,
      address: address,
      isDefault: _addresses.isEmpty,
    ));
    notifyListeners();
  }

  void updateAddress(SavedAddress a, String label, String address) {
    a.label = label;
    a.address = address;
    notifyListeners();
  }

  void removeAddress(SavedAddress a) {
    _addresses.remove(a);
    if (a.isDefault && _addresses.isNotEmpty) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();
  }

  void setDefaultAddress(SavedAddress a) {
    for (final x in _addresses) {
      x.isDefault = x == a;
    }
    notifyListeners();
  }

  // ---------- طرق الدفع ----------
  List<PaymentMethod> get payments => List.unmodifiable(_payments);

  void addCard(String title, String last4) {
    _payments.add(PaymentMethod(
      id: 'P${++_counter}',
      title: title,
      isCard: true,
      last4: last4,
    ));
    notifyListeners();
  }

  void removePayment(PaymentMethod p) {
    if (!p.isCard) return; // الكاش مينفعش يتمسح
    final wasDefault = p.isDefault;
    _payments.remove(p);
    if (wasDefault) _payments.first.isDefault = true;
    notifyListeners();
  }

  void setDefaultPayment(PaymentMethod p) {
    for (final x in _payments) {
      x.isDefault = x == p;
    }
    notifyListeners();
  }

  // ---------- الافتراضي (بيستخدمه الحجز) ----------
  SavedAddress? get defaultAddress {
    for (final a in _addresses) {
      if (a.isDefault) return a;
    }
    return null;
  }

  PaymentMethod get defaultPayment =>
      _payments.firstWhere((p) => p.isDefault, orElse: () => _payments.first);

  // ---------- المفضلة ----------
  bool isFavorite(String name) => _favorites.contains(name);

  void toggleFavorite(String name) {
    if (!_favorites.remove(name)) _favorites.add(name);
    notifyListeners();
  }

  List<TechnicianInfo> get favoriteTechnicians =>
      technicians.where((t) => _favorites.contains(t.name)).toList();
}