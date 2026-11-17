import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../database/firestore_paths.dart';
import '../models/technician_model.dart';

/// مزارع / مهيئ قاعدة البيانات الافتراضية (Database Seeder)
///
/// يضمن وجود فنيين معتمدين وبيانات متكاملة فور تشغيل التطبيق
/// سواء كان الاتصال بـ Firebase متصلاً أو يعمل دون إنترنت (Offline).
class DatabaseSeeder {
  DatabaseSeeder._();
  static final DatabaseSeeder instance = DatabaseSeeder._();

  static final List<TechnicianModel> initialTechnicians = [
    const TechnicianModel(
      id: 'tech_ahmed_ac',
      name: 'أحمد حسن',
      specialty: 'Air Conditioning',
      phone: '01012345671',
      rating: 4.9,
      ratingCount: 142,
      distanceKm: 1.2,
      isExpert: true, // خبير تكييف معتمد
      hourlyRate: 250,
      area: 'مدينة نصر، القاهرة',
      bio: 'خبير تكييفات وتبريد خبرة 15 عاماً في صيانة وتركيب كافة أنواع التكييفات الأسبليت والمركزي وشحن الفريون وإصلاح الكومبريسور.',
      isAvailable: true,
      latitude: 30.0626,
      longitude: 31.3368,
      matchPercentage: 98,
      matchReason: 'خبير معتمد في التكييف + تقييم 4.9 ★ + على بعد 1.2 كم فقط',
    ),
    const TechnicianModel(
      id: 'tech_mahmoud_plumb',
      name: 'محمود إبراهيم',
      specialty: 'Plumbing',
      phone: '01112345672',
      rating: 4.8,
      ratingCount: 98,
      distanceKm: 2.5,
      isExpert: true, // خبير سباكة معتمد
      hourlyRate: 200,
      area: 'المعادي، القاهرة',
      bio: 'سباك محترف متخصص في كشف التسريبات المخفية بأحدث أجهزة النيتروجين والترددات، وتأسيس وصيانة شبكات التغذية والصرف.',
      isAvailable: true,
      latitude: 29.9602,
      longitude: 31.2569,
      matchPercentage: 95,
      matchReason: 'خبير سباكة معتمد + كشف تسريبات + تقييم 4.8 ★',
    ),
    const TechnicianModel(
      id: 'tech_mohamed_elec',
      name: 'محمد علي',
      specialty: 'Electrical',
      phone: '01212345673',
      rating: 4.7,
      ratingCount: 76,
      distanceKm: 3.1,
      isExpert: false, // فني كهرباء عام
      hourlyRate: 150,
      area: 'الدقي، الجيزة',
      bio: 'فني كهرباء منازل ممتاز لتركيب المفاتيح، والنجف، وصيانة الأعطال السريعة والأجهزة البسيطة.',
      isAvailable: true,
      latitude: 30.0385,
      longitude: 31.2119,
      matchPercentage: 92,
      matchReason: 'فني كهرباء كفء وسريع + سعر اقتصادي + تقييم 4.7 ★',
    ),
    const TechnicianModel(
      id: 'tech_tamer_appliance',
      name: 'تامر السيد',
      specialty: 'Appliances',
      phone: '01098765431',
      rating: 4.9,
      ratingCount: 110,
      distanceKm: 4.2,
      isExpert: true, // خبير أجهزة منزلية
      hourlyRate: 220,
      area: 'مصر الجديدة، القاهرة',
      bio: 'صيانة وتصليح جميع موديلات الغسالات الأوتوماتيك والثلاجات والميكروويف، وتوفير قطع غيار أصلية بضمان معتمد.',
      isAvailable: true,
      latitude: 30.0914,
      longitude: 31.3239,
      matchPercentage: 96,
      matchReason: 'خبير أجهزة منزلية وكروت إلكترونية + تقييم 4.9 ★',
    ),
    const TechnicianModel(
      id: 'tech_karim_carpenter',
      name: 'كريم سامي',
      specialty: 'Carpentry',
      phone: '01512345675',
      rating: 4.6,
      ratingCount: 54,
      distanceKm: 5.0,
      isExpert: false, // نجار
      hourlyRate: 140,
      area: 'السادس من أكتوبر',
      bio: 'نجار أبواب وشبابيك ومطابخ وغرف نوم، فك وتركيب وصيانة الكوالين والمفصلات بدقة عالية.',
      isAvailable: true,
      latitude: 29.9723,
      longitude: 30.9548,
      matchPercentage: 90,
      matchReason: 'فني نجارة وأقفال متاح للزيارة اليوم',
    ),
    const TechnicianModel(
      id: 'tech_hossam_elec_expert',
      name: 'حسام عادل',
      specialty: 'Electrical',
      phone: '01011223344',
      rating: 4.9,
      ratingCount: 135,
      distanceKm: 2.1,
      isExpert: true, // خبير هندسة كهربائية
      hourlyRate: 280,
      area: 'التجمع، القاهرة الجديدة',
      bio: 'مهندس فني خبير شبكات ولوحات كهرباء رئيسية، ومعالجة القفلات والأحمال الزائدة وتأمين المنازل الذكية.',
      isAvailable: true,
      latitude: 30.0263,
      longitude: 31.4913,
      matchPercentage: 99,
      matchReason: 'خبير كهرباء معتمد لحالات الطوارئ واللوحات الرئيسية',
    ),
  ];

  /// جلب قائمة الفنيين من Firestore، مع استخدام القائمة المحلية كاحتياطي فوري
  Future<List<TechnicianModel>> getTechnicians() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection(FirestorePaths.technicianProfiles)
          .limit(30)
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs
            .map((d) => TechnicianModel.fromMap(d.data(), d.id))
            .toList();
      }
    } catch (e) {
      debugPrint('Firestore fetch failed or offline: $e');
    }
    return initialTechnicians;
  }

  /// زرع البيانات الافتراضية في Firestore إن كانت فارغة
  Future<void> seedIfNeeded() async {
    try {
      final collection = FirebaseFirestore.instance
          .collection(FirestorePaths.technicianProfiles);
      final snap = await collection.limit(1).get();

      if (snap.docs.isEmpty) {
        debugPrint('Seeding default Fixly technicians to Firestore...');
        for (final tech in initialTechnicians) {
          await collection.doc(tech.id).set(tech.toMap(), SetOptions(merge: true));
        }
        debugPrint('Seeding completed successfully!');
      }
    } catch (e) {
      debugPrint('Seeding skipped (offline/permission): $e');
    }
  }
}
