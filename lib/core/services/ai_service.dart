import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiService {
  static String? _workingBaseUrl;

  static final List<String> _candidateUrls = [
    'http://10.12.106.34:8080', // Host PC Wi-Fi LAN IP (changes per network)
    'http://127.0.0.1:8080',    // USB ADB Reverse Port Forward / Desktop
    'http://10.0.2.2:8080',     // Android Emulator AVD Loopback
    'http://localhost:8080',
  ];

  /// Discover a reachable backend URL using the /health endpoint.
  /// Uses a short timeout since this is just a connectivity probe.
  Future<String?> _discoverBaseUrl() async {
    for (final baseUrl in _candidateUrls) {
      try {
        final resp = await http.get(
          Uri.parse('$baseUrl/health'),
        ).timeout(const Duration(seconds: 2));
        if (resp.statusCode == 200) {
          debugPrint('AiService: Discovered backend at $baseUrl');
          return baseUrl;
        }
      } catch (_) {
        // Try next candidate
      }
    }
    return null;
  }

  Future<String> chat(List<Map<String, dynamic>> messages) async {
    // Use cached URL, or discover one
    String? baseUrl = _workingBaseUrl;
    if (baseUrl == null) {
      baseUrl = await _discoverBaseUrl();
      if (baseUrl == null) {
        debugPrint('AiService: No local backend found. Falling back to direct serverless Groq API.');
        return _chatDirectlyWithGroq(messages);
      }
      _workingBaseUrl = baseUrl;
    }

    final url = Uri.parse('$baseUrl/chat');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'messages': messages}),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String? ?? 'No response from AI Coach.';
      } else {
        debugPrint('AI Gateway Error (${response.statusCode}): ${response.body}');
        throw AiServiceException('AI Gateway returned status ${response.statusCode}.');
      }
    } on TimeoutException {
      throw AiServiceException('Request timed out. The AI model is taking too long to respond.');
    } on http.ClientException catch (e) {
      // Backend may have become unreachable — clear cache and fallback to direct Groq API
      _workingBaseUrl = null;
      debugPrint('AiService: Lost connection to backend ($e). Falling back to direct Groq API.');
      return _chatDirectlyWithGroq(messages);
    } catch (e) {
      if (e is AiServiceException) rethrow;
      _workingBaseUrl = null;
      debugPrint('AiService: Error connecting to backend ($e). Falling back to direct Groq API.');
      return _chatDirectlyWithGroq(messages);
    }
  }

  Future<String> _chatDirectlyWithGroq(List<Map<String, dynamic>> messages) async {
    final apiKey = dotenv.env['GROQ_API_KEY'] ?? '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';
    String model = dotenv.env['MODEL'] ?? 'llama-3.3-70b-versatile';

    // Auto-detect vision
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
          return choices[0]['message']['content'] as String? ?? 'No response from AI Coach.';
        }
        return 'No response from AI Coach.';
      } else {
        debugPrint('Direct Groq API Error (${response.statusCode}): ${response.body}');
        throw AiServiceException('Groq API returned status ${response.statusCode}. Please check your API key.');
      }
    } on TimeoutException {
      throw AiServiceException('Request timed out. The AI model is taking too long to respond.');
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
