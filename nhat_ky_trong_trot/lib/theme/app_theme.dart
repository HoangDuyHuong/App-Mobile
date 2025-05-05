import 'package:flutter/material.dart';

class AppTheme {
  // Màu sắc chủ đạo
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color background = Color.fromARGB(255, 220, 246, 193);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFF546E7A);
  static const Color secondaryBackground = Color(0xFFE8F5E9); // xanh nhạt hơn

  // Phông chữ
  static const String fontFamily = 'Roboto';

  // Chủ đề chính
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryGreen,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: lightGreen,
        surface: cardColor,
        background: background,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: textLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textLight,
        ),
      ),
    );
  }

  // Box shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];
}