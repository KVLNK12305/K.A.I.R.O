import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/github_pr.dart';

class GitHubAuthException implements Exception {
  final String message;
  GitHubAuthException(this.message);
  @override
  String toString() => message;
}

class GitHubService {
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('github_token') ?? '';

    if (token.trim().isEmpty) {
      throw GitHubAuthException('GitHub PAT not found. Please set it in Settings.');
    }

    return token.trim();
  }

  Future<List<GitHubPR>> fetchActivePRs() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('https://api.github.com/search/issues?q=is:pr+is:open+author:@me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map((json) => GitHubPR.fromJson(json)).toList();
    } else {
      debugPrint("GitHub API Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load GitHub PRs. Status: ${response.statusCode}');
    }
  }
}
