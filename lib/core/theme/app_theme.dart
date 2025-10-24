import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFBC02D);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color onPrimaryColor = Color(0xFF000000);
  static const Color textColor = Color(0xFF212121);
  static const Color subtleShadow = Color(0x1A000000);
  static const Color borderColor = Color(0xFFEEEEEE);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        background: backgroundColor,
        onBackground: textColor,
        surface: backgroundColor,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData.light().textTheme.apply(bodyColor: textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: backgroundColor,
        elevation: 4,
        shadowColor: subtleShadow,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
    );
  }
}
