import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fixly/main.dart' show appLocale;

/// Design tokens for the Admin console (taken from the HTML mockup).
class A {
  A._();

  static const navy = Color(0xFF0B1F3A);
  static const cyan = Color(0xFF12B5D6);
  static const blue = Color(0xFF1E6FE0);
  static const blueTint = Color(0xFFDCEBFF);
  static const blueSoft = Color(0xFFBBD4F7);
  static const bg = Color(0xFFF6F8FB);
  static const border = Color(0xFFE3E8EF);
  static const inputBorder = Color(0xFFD5DCE6);
  static const grey = Color(0xFF5B6B82);
  static const track = Color(0xFFEEF2F7);
  static const white = Colors.white;

  static const green = Color(0xFF1F9D63);
  static const greenBright = Color(0xFF2ED47A);
  static const greenText = Color(0xFF0B6B3F);
  static const greenTint = Color(0xFFDDF5E8);

  static const amber = Color(0xFFF59E0B);
  static const amberText = Color(0xFF8A4B04);
  static const amberTint = Color(0xFFFDEFCB);
  static const amberBar = Color(0xFFF7DDA0);

  static const red = Color(0xFFD92D20);
  static const redText = Color(0xFFB42318);
  static const redTint = Color(0xFFFDE3E1);
  static const redBar = Color(0xFFF4B9B3);

  static const warnBg = Color(0xFFFEF0C7);
  static const warnText = Color(0xFF7A2E0E);

  static const sideItem = Color(0xFFB8C7DE);
  static const sideActive = Color(0xFF1B3358);
  static const sub = Color(0xFF9FB4D3);
  static const signOut = Color(0xFFFFB4AB);
  static const linkBlue = Color(0xFF1558D6);
}

/// Current language helpers (the app switches language through [appLocale]).
bool get isAr => appLocale.value.languageCode == 'ar';

String tr(String en, String ar) => isAr ? ar : en;

/// Text style using Manrope (EN) / Cairo (AR), like the rest of the app.
TextStyle aText(
  double size, {
  FontWeight weight = FontWeight.w700,
  Color color = A.navy,
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.getFont(
    isAr ? 'Cairo' : 'Manrope',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Shows the small dark pill used by the mockup for unavailable pages.
void showAdminToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: A.navy,
      elevation: 0,
      duration: const Duration(milliseconds: 1500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 24),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: aText(13, color: Colors.white),
      ),
    ),
  );
}
