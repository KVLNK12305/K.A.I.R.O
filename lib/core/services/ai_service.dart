import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  // Dev-only fallbacks via `--dart-define-from-file=.env`. Anything passed this way is
  // compiled into the binary, so release builds should rely on the key entered in Profile.
  static const String _devApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const String _model = String.fromEnvironment('MODEL', defaultValue: 'llama-3.3-70b-versatile');

  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final prefKey = prefs.getString('groq_api_key')?.trim() ?? '';
    if (prefKey.isNotEmpty) return prefKey;
    return _devApiKey.trim();
  }

  Future<String> chat(List<Map<String, dynamic>> messages) async {
    final apiKey = await _getApiKey();
    if (apiKey.isEmpty) {
      throw AiServiceException('Groq API Key not configured. Configure your key in Profile Settings.');
    }

    String model = _model;

    // Auto-detect vision payload
    for (final msg in messages) {
      if (msg['content'] is! String) {
        model = 'llama-3.2-90b-vision-preview';
        break;
      }
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'] as String? ?? 'No response from AI Guide.';
        }
        return 'No response from AI Guide.';
      } else {
        debugPrint('Direct Groq API Error (${response.statusCode}): ${response.body}');
        throw AiServiceException('Groq API returned status ${response.statusCode}. Please verify your API key.');
      }
    } on TimeoutException {
      throw AiServiceException('Request timed out. The AI model took too long to respond.');
    } catch (e) {
      if (e is AiServiceException) rethrow;
      throw AiServiceException('Connection error: $e');
    }
  }
}

/// Typed exception so the UI layer can distinguish errors from real AI responses.
class AiServiceException implements Exception {
  final String message;
  AiServiceException(this.message);

  @override
  String toString() => message;
}

