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
    );

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
}
