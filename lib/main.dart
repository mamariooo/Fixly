import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Splash/Splash.dart';
import 'admin/admin_login.dart';
import 'core/services/database_seeder.dart';
import 'firebase_options.dart';
import 'home/Dashboard_Technician/technician_home_screen.dart';
import 'home/home.dart';
import 'home/nearby_technicians_screen.dart';

final ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('ar'));

void changeLanguage(String languageCode) {
  if (languageCode != 'ar' && languageCode != 'en') {
    return;
  }

  if (appLocale.value.languageCode != languageCode) {
    appLocale.value = Locale(languageCode);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Google Sign-In
    await GoogleSignIn.instance.initialize(
      serverClientId: '998174646288-0sc6rvmk1b3qu36ln995acifec1fq7n4.apps.googleusercontent.com',
    );

    // زرع الفنيين الافتراضيين في الخلفية
    DatabaseSeeder.instance.seedIfNeeded();
  } catch (e) {
    debugPrint('Firebase / Google init notice: $e');
  }

  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (e) {
    debugPrint('dotenv notice: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        final isArabic = locale.languageCode == 'ar';

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fixly',
          locale: locale,
          supportedLocales: const [Locale('ar'), Locale('en')],

          // إعدادات الترجمة الداخلية في Flutter
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF6F8FC),
            textTheme: isArabic
                ? GoogleFonts.cairoTextTheme()
                : GoogleFonts.manropeTextTheme(),
          ),

          builder: (context, child) {
            return Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },

          // نقطة البداية
          home: const FixlyApp(),

          // مسارات التطبيق (End Points) المخصصة
          routes: {
            '/admin': (context) =>
                const AdminLoginScreen(), // Endpoint خاص بالأدمن
            '/home': (context) => const HomeScreen(),
            '/technician': (context) => const TechnicianHomeScreen(),
            '/nearby': (context) => const NearbyTechniciansScreen(),
          },
        );
      },
    );
  }
}
