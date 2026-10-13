import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixly/Splash/Splash.dart';

final ValueNotifier<Locale> appLocale =
    ValueNotifier(const Locale('en'));

void changeLanguage(String languageCode) {
  if (languageCode != 'ar' && languageCode != 'en') {
    return;
  }

  if (appLocale.value.languageCode != languageCode) {
    appLocale.value = Locale(languageCode);
  }
}

void main() {
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

          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],

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
              textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },

          home: const FixlyApp(),
        );
      },
    );
  }
}