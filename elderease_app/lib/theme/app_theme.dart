import 'package:flutter/material.dart';

class AppTheme {
  // Premium Health & Fintech Inspired Palette
  static const Color primaryBlue = Color(0xFF2563EB); // Soft Blue
  static const Color primaryBlueLight = Color(0xFF60A5FA); // Light Blue Gradient element
  static const Color backgroundOffWhite = Color(0xFFF8FAFC);
  static const Color textDarkGray = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color cardWhite = Colors.white;

  static ThemeData get premiumTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundOffWhite,
      // Minimal app bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textDarkGray),
        titleTextStyle: TextStyle(
          color: textDarkGray,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDarkGray, letterSpacing: -1.0),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textDarkGray, letterSpacing: -0.5),
        bodyLarge: TextStyle(fontSize: 20, color: textDarkGray, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 16, color: textMuted),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryBlue.withValues(alpha: 0.4),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textDarkGray,
          minimumSize: const Size(double.infinity, 60),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
