import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color white = Color(0xffFFFFFF);
  static const Color primary = Color(0xff151414);
  static const Color gray = Color(0xffB0AEAE);



  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.notoNaskhArabic(fontSize: 14, color: AppTheme.primary),
      bodyLarge: GoogleFonts.notoNaskhArabic(fontSize: 20, color: AppTheme.primary),
      titleMedium: GoogleFonts.notoNaskhArabic(fontSize: 17, color: AppTheme.primary),
    ),
  );
}
