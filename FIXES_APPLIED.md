# التعديلات اللي اتعملت على Fixly

## 1. مشكلة تكرار الأونبوردينج ورجوع تسجيل الدخول (اتظبطت)
**الملف:** `lib/Splash/Splash.dart`

- التطبيق بقى يتشك على `FirebaseAuth.instance.currentUser` أول ما يفتح.
- لو فيه سيشن شغالة → بيدخل على الصفحة الصح مباشرة (Home أو Technician Home) حسب الدور والحالة.
- الأونبوردينج بيظهر مرة واحدة بس (أول تثبيت) باستخدام `SharedPreferences` بمفتاح `onboarding_completed`.
- لو الفني لسه `pending_approval` → بيفضل في وضع العميل ومش بيدخل داشبورد الفني.

**الملف:** `lib/Onboarding/onboarding_screen.dart`
- لما المستخدم يخلص الأونبوردينج بيتسجل العلم `onboarding_completed = true`.

## 2. ثغرة تحويل المستخدم لفني بدون موافقة أدمن (اتسدت)
**الملف:** `lib/core/database/user_repository.dart`

- دالة `enableTechnicianRole` بقت تحط الحساب في حالة `pending_approval` ومش بتحول `activeRole` لفني.
- دالة `switchActiveRole` لو حاولت تحول لفني وهي لسه مش موافق عليها → بترمي Exception وبتمنع التحويل.

## 3. اللغة في البوتوم بار (اتحسنت)
**الملف:** `lib/home/home.dart`

- البوتوم نافيجيشن بقى بيستخدم `S.home / S.services / S.bookings / S.messages / S.profile` من `app_strings.dart`.
- بيتحدث تلقائي لما تغير اللغة (ValueListenableBuilder).

## 4. باكدج جديد واحد بس
**الملف:** `pubspec.yaml`
- ضفت `shared_preferences: ^2.3.3` عشان نحفظ حالة الأونبوردينج والسيشن بشكل نظيف.
- باقي الباكدجز زي ما هي (Firebase + Google Fonts + AI).

## طريقة التشغيل
```bash
flutter pub get
flutter run
```

## ملاحظات مهمة
- الخرائط والموقع المتقدم مش متظبطين دلوقتي (حسب طلبك إنهم مش أولوية).
- لسه في شاشات كتير نصوصها hardcoded إنجليزي، محتاجين نحولها تدريجياً لـ `S.t(...)`.
- لو عايز ترجع الأونبوردينج تاني امسح بيانات التطبيق أو امسح المفتاح من SharedPreferences.
