import 'package:flutter/material.dart';

class AppTheme {
  // Palette (premium dark + violet accent)
  static const _bg = Color(0xFF0E1020);
  static const _card = Color(0xFF171A2E);
  static const _card2 = Color(0xFF1D2140);
  static const _stroke = Color(0xFF2B315E);
  static const _text = Color(0xFFF4F5FF);
  static const _muted = Color(0xFFB8BCE6);
  static const _accent = Color(0xFF6C4DFF);
  static const _accent2 = Color(0xFF8B5CFF);
  static const _danger = Color(0xFFFF5A7A);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: _bg,
      colorScheme: const ColorScheme.dark(
        primary: _accent,
        secondary: _accent2,
        surface: _card,
        surfaceContainerHighest: _card2,
        outline: _stroke,
        error: _danger,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _text),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _text),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _text),
        bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _text),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _muted),
        labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _muted),
      ),
      cardTheme: CardThemeData(
        color: _card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _stroke, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.2),
        ),
        labelStyle: const TextStyle(color: _muted),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _card,
        indicatorColor: Color(0xFF2B315E),
      ),
    );
  }
}
