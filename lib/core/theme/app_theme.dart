import 'package:flutter/material.dart';

class AppTheme {
  // ─── BRUTALIST COLOR PALETTE ───
  static const Color background = Color(0xFF000000); // Pure Black
  static const Color surface = Color(0xFF111111); // Dark Gray Surface
  static const Color primary = Color(0xFFFFFFFF); // Pure White
  static const Color secondary = Color(0xFF888888); // Neutral Data Gray
  
  static const Color warning = Color(0xFFFF2222); // Harsh Neon Red
  static const Color success = Color(0xFF22FF22); // Harsh Neon Green
  static const Color accent = Color(0xFFFFFF00); // Piercing Yellow
  static const Color border = Color(0xFF333333); // Harsh Border Gray

  // ─── NEO-PASTEL COLOR-BLOCK PALETTE ───
  static const Color pastelPink = Color(0xFFF7C5DD);
  static const Color pastelBlue = Color(0xFF8DC0FA);
  static const Color pastelGreen = Color(0xFFC7F3C6);
  static const Color pastelAmber = Color(0xFFFAD168);
  static const Color coralRed = Color(0xFFFF5232);
  static const Color inkBlack = Color(0xFF0F0F12);
  static const Color cardWhite = Color(0xFFFFFFFF);

  static ThemeData get brutalist => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    fontFamily: 'monospace', // Brutalist monospace typography
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: warning,
      onPrimary: background,
      onSecondary: background,
      onError: primary,
      onSurface: primary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0, color: primary),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: primary),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: primary),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: primary),
      bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.5, color: secondary),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: secondary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: secondary, fontFamily: 'monospace'),
      iconTheme: IconThemeData(color: primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: surface,
        foregroundColor: primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Hard edges
        side: const BorderSide(color: border, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontFamily: 'monospace'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: border, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontFamily: 'monospace'),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: border, width: 1)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: border, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: primary, width: 2)),
      hintStyle: TextStyle(color: secondary, fontSize: 14, fontFamily: 'monospace'),
      labelStyle: TextStyle(color: secondary, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
    ),
  );
}
