import 'package:flutter/material.dart';

class AppTheme {
  // ─── NEO-PASTEL COLOR-BLOCK PALETTE ───
  static const Color pastelPink = Color(0xFFF7C5DD);
  static const Color pastelBlue = Color(0xFF8DC0FA);
  static const Color pastelGreen = Color(0xFFC7F3C6);
  static const Color pastelAmber = Color(0xFFFAD168);
  static const Color pastelMint = Color(0xFFC7F3C6);
  static const Color pastelRose = Color(0xFFF7C5DD);
  static const Color pastelPurple = Color(0xFFD1C4E9);
  static const Color coralRed = Color(0xFFFF5232);
  static const Color inkBlack = Color(0xFF0F0F12);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // ─── VIBRANT PREMIUM PALETTE (DUOLINGO/SWIGGY AESTHETIC) ───
  static const Color background = Color(0xFF000000); // Pure Black
  static const Color surface = Color(0xFF2A2A38); // Deep Translucent Purple-ish Surface
  static const Color primary = Color(0xFF1CB0F6); // Vibrant Blue
  static const Color secondary = Color(0xFFB0B0C0); // Soft Text Gray
  
  static const Color warning = Color(0xFFFF4B4B); // Vibrant Red/Orange
  static const Color success = Color(0xFF58CC02); // Vibrant Green
  static const Color accent = Color(0xFFCE82FF); // Vibrant Purple
  static const Color border = Color(0xFF3E3E52); // Soft Border
  
  static const Color cyan = Color(0xFF26C6DA); // Vibrant Cyan

  static ThemeData get brutalist => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    // Modern Sans-Serif Typography
    fontFamily: 'sans-serif',
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: warning,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0, color: Colors.white),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.white),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.0, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.2, color: secondary),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: secondary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: border, width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), // Fully rounded pill
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), // Fully rounded pill
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      hintStyle: const TextStyle(color: secondary, fontSize: 14, fontWeight: FontWeight.w500),
      labelStyle: const TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: background,
      selectedItemColor: primary,
      unselectedItemColor: secondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );
}
