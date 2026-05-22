import 'package:flutter/material.dart';

class AppTheme {
  // Light palette (matches the FigJam light look)
  static const _lBg = Color(0xFFF7F7FB);
  static const _lCard = Colors.white;
  static const _lStroke = Color(0xFFE6E7F2);
  static const _lText = Color(0xFF101226);
  static const _lMuted = Color(0xFF5F678A);
  static const _accent = Color(0xFF6C4DFF);
  static const _accent2 = Color(0xFF8B5CFF);
  static const _danger = Color(0xFFFF3B6B);

  // Dark palette (optional)
  static const _dBg = Color(0xFF0E1020);
  static const _dCard = Color(0xFF171A2E);
  static const _dCard2 = Color(0xFF1D2140);
  static const _dStroke = Color(0xFF2B315E);
  static const _dText = Color(0xFFF4F5FF);
  static const _dMuted = Color(0xFFB8BCE6);

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: _lBg,
      colorScheme: const ColorScheme.light(
        primary: _accent,
        secondary: _accent2,
        surface: _lCard,
        outline: _lStroke,
        error: _danger,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _lText),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _lText),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _lText),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _lText),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _lMuted),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _lMuted),
      ),
      cardTheme: CardThemeData(
        color: _lCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _lStroke, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lStroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.2),
        ),
        labelStyle: const TextStyle(color: _lMuted),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _lCard,
        indicatorColor: Color(0xFFEDEEFD),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: _dBg,
      colorScheme: const ColorScheme.dark(
        primary: _accent,
        secondary: _accent2,
        surface: _dCard,
        surfaceContainerHighest: _dCard2,
        outline: _dStroke,
        error: _danger,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _dText),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _dText),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _dText),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _dText),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _dMuted),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _dMuted),
      ),
      cardTheme: CardThemeData(
        color: _dCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _dStroke, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _dCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _dStroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _dStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.2),
        ),
        labelStyle: const TextStyle(color: _dMuted),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _dCard,
        indicatorColor: Color(0xFF2B315E),
      ),
    );
  }
}
