import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color white = Color(0xffFFFFFF);
  static const Color primary = Color(0xff151414);
  static const Color gray = Color(0xffB0AEAE);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: primary),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.notoNaskhArabic(fontSize: 14, color: AppTheme.primary),
      bodyLarge: GoogleFonts.notoNaskhArabic(fontSize: 20, color: AppTheme.primary),
      titleMedium: GoogleFonts.notoNaskhArabic(fontSize: 17, color: AppTheme.primary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xff151414),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.notoNaskhArabic(fontSize: 14, color: Colors.white),
      bodyLarge: GoogleFonts.notoNaskhArabic(fontSize: 20, color: Colors.white),
      titleMedium: GoogleFonts.notoNaskhArabic(fontSize: 17, color: Colors.white),
    ),
  );
}

