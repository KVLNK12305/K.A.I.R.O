import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF050505),
    primaryColor: Colors.blueGrey,
    fontFamily: 'Roboto',
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xFF64FFDA),
      surface: Color(0xFF121212),
    ),
  );
}
