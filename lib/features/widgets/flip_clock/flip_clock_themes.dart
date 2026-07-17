import 'package:flutter/material.dart';

/// Visual theme configuration for the flip clock.
class FlipClockThemeData {
  final String name;
  final Color cardColor;
  final Color cardHighlight;
  final Color textColor;
  final List<Color> textGradient;
  final Color shadowColor;
  final Color dividerColor;
  final Color reflectionColor;
  final double reflectionOpacity;
  final Color glowColor;
  final double glowIntensity;
  final Color dateTextColor;
  final Color amPmColor;
  final Color backgroundAccent;
  final double borderRadius;

  const FlipClockThemeData({
    required this.name,
    required this.cardColor,
    required this.cardHighlight,
    required this.textColor,
    required this.textGradient,
    required this.shadowColor,
    required this.dividerColor,
    required this.reflectionColor,
    required this.reflectionOpacity,
    required this.glowColor,
    required this.glowIntensity,
    required this.dateTextColor,
    required this.amPmColor,
    required this.backgroundAccent,
    required this.borderRadius,
  });
}

/// The four premium flip clock themes.
class FlipClockThemes {
  FlipClockThemes._();

  static const midnightObsidian = FlipClockThemeData(
    name: 'Midnight Obsidian',
    cardColor: Color(0xFF0D0D0D),
    cardHighlight: Color(0xFF1A1A1A),
    textColor: Color(0xFFF0F0F0),
    textGradient: [Color(0xFFFFFFFF), Color(0xFFCCCCCC)],
    shadowColor: Color(0xFF000000),
    dividerColor: Color(0xFF2A2A2A),
    reflectionColor: Color(0xFFAAAAAA),
    reflectionOpacity: 0.06,
    glowColor: Color(0xFF888888),
    glowIntensity: 0.15,
    dateTextColor: Color(0xFF777777),
    amPmColor: Color(0xFF555555),
    backgroundAccent: Color(0xFF111111),
    borderRadius: 8.0,
  );

  static const neonNoir = FlipClockThemeData(
    name: 'Neon Noir',
    cardColor: Color(0xFF0A0A14),
    cardHighlight: Color(0xFF12121F),
    textColor: Color(0xFF00FFFF),
    textGradient: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
    shadowColor: Color(0xFF000022),
    dividerColor: Color(0xFF1A1A2E),
    reflectionColor: Color(0xFF00FFFF),
    reflectionOpacity: 0.08,
    glowColor: Color(0xFF00FFFF),
    glowIntensity: 0.35,
    dateTextColor: Color(0xFF00CCCC),
    amPmColor: Color(0xFFFF00FF),
    backgroundAccent: Color(0xFF0A0A1A),
    borderRadius: 6.0,
  );

  static const ivoryClassic = FlipClockThemeData(
    name: 'Ivory Classic',
    cardColor: Color(0xFFF5F0E8),
    cardHighlight: Color(0xFFFAF6F0),
    textColor: Color(0xFF2C2418),
    textGradient: [Color(0xFFB8860B), Color(0xFF8B6914)],
    shadowColor: Color(0xFF8B7D6B),
    dividerColor: Color(0xFFD4C4A8),
    reflectionColor: Color(0xFFFFD700),
    reflectionOpacity: 0.1,
    glowColor: Color(0xFFDAA520),
    glowIntensity: 0.2,
    dateTextColor: Color(0xFF8B7355),
    amPmColor: Color(0xFFB8860B),
    backgroundAccent: Color(0xFFEDE5D8),
    borderRadius: 10.0,
  );

  static const holographic = FlipClockThemeData(
    name: 'Holographic',
    cardColor: Color(0xFF0C0C14),
    cardHighlight: Color(0xFF14141F),
    textColor: Color(0xFFFFFFFF),
    textGradient: [
      Color(0xFFFF6B6B),
      Color(0xFFFFE66D),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
      Color(0xFFDDA0DD),
    ],
    shadowColor: Color(0xFF1A0033),
    dividerColor: Color(0xFF1E1E2E),
    reflectionColor: Color(0xFF9B59B6),
    reflectionOpacity: 0.12,
    glowColor: Color(0xFF8B5CF6),
    glowIntensity: 0.3,
    dateTextColor: Color(0xFFB8B8CC),
    amPmColor: Color(0xFF8B5CF6),
    backgroundAccent: Color(0xFF0E0E18),
    borderRadius: 12.0,
  );

  static const List<FlipClockThemeData> all = [
    midnightObsidian,
    neonNoir,
    ivoryClassic,
    holographic,
  ];
}
