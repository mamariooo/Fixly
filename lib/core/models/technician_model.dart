import 'dart:math';

/// نموذج بيانات الفني (Technician Model)
class TechnicianModel {
  final String id;
  final String name;
  final String specialty; // Air Conditioning, Plumbing, Electrical, Appliances, Carpentry
  final String phone;
  final String? photoUrl;
  final double rating;
  final int ratingCount;
  final double distanceKm;
  final bool isExpert; // خبير معتمد (True) أم فني عادي (False)
  final int hourlyRate; // السعر التقديري / بالساعة بالجنيه المصري
  final String area;
  final String bio;
  final bool isAvailable;
  final double? latitude;
  final double? longitude;
  final int matchPercentage; // نسبة توافق الذكاء الاصطناعي (مثلاً 98%)
  final String matchReason; // سبب ترشيح الذكاء الاصطناعي للفني

  const TechnicianModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    this.photoUrl,
    this.rating = 4.8,
    this.ratingCount = 50,
    this.distanceKm = 2.0,
    this.isExpert = false,
    this.hourlyRate = 180,
    this.area = 'القاهرة',
    this.bio = '',
    this.isAvailable = true,
    this.latitude,
    this.longitude,
    this.matchPercentage = 90,
    this.matchReason = '',
  });

  /// حساب المسافة بالكيلومتر باستخدام صيغة Haversine
  static double calculateDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    final km = 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
    return double.parse(km.toStringAsFixed(1));
  }

  TechnicianModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? phone,
    String? photoUrl,
    double? rating,
    int? ratingCount,
    double? distanceKm,
    bool? isExpert,
    int? hourlyRate,
    String? area,
    String? bio,
    bool? isAvailable,
    double? latitude,
    double? longitude,
    int? matchPercentage,
    String? matchReason,
  }) {
    return TechnicianModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      distanceKm: distanceKm ?? this.distanceKm,
      isExpert: isExpert ?? this.isExpert,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      area: area ?? this.area,
      bio: bio ?? this.bio,
      isAvailable: isAvailable ?? this.isAvailable,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      matchReason: matchReason ?? this.matchReason,
    );
  }

  factory TechnicianModel.fromMap(Map<String, dynamic> map, String docId) {
    return TechnicianModel(
      id: docId,
      name: (map['name'] as String?) ?? (map['fullName'] as String?) ?? 'فني Fixly',
      specialty: (map['specialty'] as String?) ?? 'Air Conditioning',
      phone: (map['phone'] as String?) ?? '',
      photoUrl: map['photoUrl'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 50,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 2.0,
      isExpert: (map['isExpert'] as bool?) ?? false,
      hourlyRate: (map['hourlyRate'] as num?)?.toInt() ?? 180,
      area: (map['area'] as String?) ?? 'القاهرة',
      bio: (map['bio'] as String?) ?? '',
      isAvailable: (map['isAvailable'] as bool?) ?? true,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      matchPercentage: (map['matchPercentage'] as num?)?.toInt() ?? 90,
      matchReason: (map['matchReason'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fullName': name,
      'specialty': specialty,
      'phone': phone,
      'photoUrl': photoUrl,
      'rating': rating,
      'ratingCount': ratingCount,
      'distanceKm': distanceKm,
      'isExpert': isExpert,
      'hourlyRate': hourlyRate,
      'area': area,
      'bio': bio,
      'isAvailable': isAvailable,
      'latitude': latitude,
      'longitude': longitude,
      'matchPercentage': matchPercentage,
      'matchReason': matchReason,
    };
  }
}
