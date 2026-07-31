import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WakaTimeService {
  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('wakatime_key') ?? '';

    if (key.trim().isEmpty) {
      throw Exception('WakaTime API Key not found. Please set it in Settings.');
    }

    return key.trim();
  }

  Future<String> fetchTodayCodingHours() async {
    final apiKey = await _getApiKey();
    final encodedKey = base64Encode(utf8.encode(apiKey));

    final response = await http.get(
      Uri.parse('https://wakatime.com/api/v1/users/current/summaries?range=today'),
      headers: {
        'Authorization': 'Basic $encodedKey',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['data'] as List<dynamic>? ?? [];
      if (items.isNotEmpty) {
        final grandTotal = items.first['grand_total'];
        if (grandTotal != null && grandTotal['text'] != null) {
          return grandTotal['text']; // e.g. "3 hrs 12 mins"
        }
      }
      return "0 hrs 0 mins";
    } else {
      debugPrint("WakaTime API Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load WakaTime data. Status: ${response.statusCode}');
    }
  }

  /// Fetches detailed coding telemetry including top language, project, total seconds, and stagnation risk.
  Future<WakaTimeTelemetry> fetchCodingSessionTelemetry() async {
    try {
      final apiKey = await _getApiKey();
      final encodedKey = base64Encode(utf8.encode(apiKey));

      final response = await http.get(
        Uri.parse('https://wakatime.com/api/v1/users/current/summaries?range=today'),
        headers: {
          'Authorization': 'Basic $encodedKey',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['data'] as List<dynamic>? ?? [];
        if (items.isNotEmpty) {
          final first = items.first;
          final grandTotal = first['grand_total'] ?? {};
          final totalSeconds = (grandTotal['total_seconds'] as num?)?.toDouble() ?? 0.0;
          final formattedTime = grandTotal['text']?.toString() ?? '0 hrs 0 mins';

          final projects = first['projects'] as List<dynamic>? ?? [];
          final topProject = projects.isNotEmpty ? projects.first['name']?.toString() ?? 'General' : 'General';

          final languages = first['languages'] as List<dynamic>? ?? [];
          final topLanguage = languages.isNotEmpty ? languages.first['name']?.toString() ?? 'Dart' : 'Dart';

          // Stagnation risk: > 3.5 hours on single project without milestone progress
          final isStagnant = totalSeconds > 12600;

          return WakaTimeTelemetry(
            formattedTotalTime: formattedTime,
            totalSeconds: totalSeconds,
            topProject: topProject,
            topLanguage: topLanguage,
            isStagnantDebugging: isStagnant,
            stagnationWarning: isStagnant
                ? '⚠️ STAGNATION DETECTED: Over 3.5h coding today. Check for debugging loops.'
                : 'VELOCITY HEALTHY: Flow state maintained on $topProject.',
          );
        }
      }
    } catch (e) {
      debugPrint('WakaTime telemetry fallback: $e');
    }

    return WakaTimeTelemetry(
      formattedTotalTime: '0 hrs 0 mins',
      totalSeconds: 0.0,
      topProject: 'K.A.I.R.O',
      topLanguage: 'Dart',
      isStagnantDebugging: false,
      stagnationWarning: 'VELOCITY UNKNOWN: Connect WakaTime API Key in Settings.',
    );
  }
}

class WakaTimeTelemetry {
  final String formattedTotalTime;
  final double totalSeconds;
  final String topProject;
  final String topLanguage;
  final bool isStagnantDebugging;
  final String stagnationWarning;

  WakaTimeTelemetry({
    required this.formattedTotalTime,
    required this.totalSeconds,
    required this.topProject,
    required this.topLanguage,
    required this.isStagnantDebugging,
    required this.stagnationWarning,
  });
}

