import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixly/Splash/Splash.dart';

<<<<<<< HEAD
final ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('en'));
=======
final ValueNotifier<Locale> appLocale =
    ValueNotifier(const Locale('en'));
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

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

<<<<<<< HEAD
          supportedLocales: const [Locale('en'), Locale('ar')],
=======
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df

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
<<<<<<< HEAD
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
=======
              textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
              child: child ?? const SizedBox.shrink(),
            );
          },

          home: const FixlyApp(),
        );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> d7a47081bc9218e43dd8e7d30092cfc45e7b93df
