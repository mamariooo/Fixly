import '../../main.dart';

/// نصوص التطبيق ثنائية اللغة (Arabic & English Localization)
class S {
  S._();

  static bool get isAr => appLocale.value.languageCode == 'ar';

  static String t(String en, String ar) => isAr ? ar : en;

  // عام (Common)
  static String get appName => t('Fixly', 'فيكسلي');
  static String get home => t('Home', 'الرئيسية');
  static String get services => t('Services', 'الخدمات');
  static String get bookings => t('Bookings', 'الحجوزات');
  static String get messages => t('Messages', 'الرسائل');
  static String get profile => t('Profile', 'حسابي');
  static String get login => t('Log in', 'تسجيل الدخول');
  static String get signup => t('Sign up', 'إنشاء حساب');
  static String get logout => t('Log out', 'تسجيل الخروج');
  static String get save => t('Save', 'حفظ');
  static String get cancel => t('Cancel', 'إلغاء');
  static String get continueText => t('Continue', 'متابعة');
  static String get errorGeneric => t('Something went wrong', 'حدث خطأ ما');
  static String get retry => t('Retry', 'إعادة المحاولة');
  static String get back => t('Back', 'رجوع');

  // المصادقة (Auth)
  static String get emailOrPhone => t('Email or phone', 'البريد أو الهاتف');
  static String get password => t('Password', 'كلمة المرور');
  static String get forgotPassword => t('Forgot password?', 'نسيت كلمة المرور؟');
  static String get fullName => t('Full Name', 'الاسم بالكامل');

  // الذكاء الاصطناعي (AI & Diagnosis)
  static String get reportProblem => t('Report a problem', 'الإبلاغ عن مشكلة');
  static String get describeIssue => t('Describe the issue', 'اوصف المشكلة');
  static String get uploadPhoto => t('Upload a photo', 'ارفع صورة');
  static String get sendToTechnician => t('Send to technician', 'إرسال للفني');
  static String get analysisPending => t('Fixly AI is analyzing...', 'الذكاء الاصطناعي يقوم بالتحليل...');
  static String get aiDiagnosis => t('AI Diagnosis', 'تشخيص الذكاء الاصطناعي');
  static String get detectedService => t('Detected Service', 'الخدمة المقترحة');
  static String get possibleIssue => t('Possible Issue', 'العطل المحتمل');
  static String get aiConfidence => t('AI Confidence', 'دقة التشخيص');
  static String get needsExpert => t('Requires Certified Expert ★', 'يتطلب خبيراً معتمداً ★');
  static String get generalTech => t('Standard Maintenance', 'صيانة عامة');
  static String get safetyTips => t('Safety Advice', 'نصيحة أمان');

  // ترشيح واختيار الفنيين (Technician Matching)
  static String get nearbyTechnicians => t('Nearby Technicians', 'الفنيون القريبون');
  static String get aiRecommended => t('AI Recommended', 'ترشيح الذكاء الاصطناعي');
  static String get topRated => t('Top Rated', 'الأعلى تقييماً');
  static String get closest => t('Closest Distance', 'الأقرب مسافة');
  static String get expertOnly => t('Experts Only', 'خبراء معتمدون');
  static String get certifiedExpert => t('Certified Master Expert', 'خبير معتمد');
  static String get certifiedTech => t('Certified Technician', 'فني معتمد');
  static String get matchScore => t('AI Match', 'توافق AI');
  static String get requestTechnician => t('Request Technician', 'طلب الفني');
  static String get kmAway => t('km away', 'كم عن موقعك');
  static String get estimatedRate => t('Estimated Base Rate', 'السعر التقديري');

  // الدفع وتحديد السعر (Pricing & Payment)
  static String get finalPrice => t('Final Agreed Price', 'السعر النهائي');
  static String get quotePrice => t('Quote Price', 'تحديد السعر');
  static String get acceptWithPrice => t('Accept & Set Price', 'قبول وتحديد السعر');
  static String get rejectRequest => t('Reject Request', 'رفض الطلب');
  static String get paymentMethod => t('Payment Method', 'طريقة الدفع');
  static String get cash => t('Cash on Completion', 'كاش عند الانتهاء');
  static String get visa => t('Visa / Card', 'فيزا / بطاقة بنكية');
  static String get payNow => t('Pay Now', 'سداد الآن');
  static String get paidSuccess => t('Paid Successfully ✓', 'تم السداد بنجاح ✓');
  static String get egp => t('EGP', 'ج.م');

  // الدور المزدوج (Dual Role)
  static String get switchToTech => t('Switch to Technician Mode', 'التبديل إلى وضع الفني');
  static String get switchToClient => t('Switch to Client Mode', 'التبديل إلى وضع العميل');
  static String get becomeTech => t('Become a Technician', 'انضم كفني في Fixly');
}
