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

class GitHubRepoItem {
  final String fullName;
  final String name;
  final String description;
  final String defaultBranch;
  final bool isPrivate;
  final String updatedAt;
  final String? language;

  GitHubRepoItem({
    required this.fullName,
    required this.name,
    required this.description,
    required this.defaultBranch,
    required this.isPrivate,
    required this.updatedAt,
    this.language,
  });

  factory GitHubRepoItem.fromJson(Map<String, dynamic> json) {
    return GitHubRepoItem(
      fullName: json['full_name'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      defaultBranch: json['default_branch'] ?? 'main',
      isPrivate: json['private'] == true,
      updatedAt: json['updated_at'] ?? '',
      language: json['language'],
    );
  }
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

  /// Fetches all repositories accessible by the user's PAT.
  Future<List<GitHubRepoItem>> fetchUserRepositories() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('https://api.github.com/user/repos?sort=updated&per_page=100&affiliation=owner,collaborator,organization_member'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GitHubRepoItem.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      debugPrint("GitHub Repos API Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load GitHub repositories. Status: ${response.statusCode}');
    }
  }

  /// Commits or updates a file (such as a Mermaid architecture diagram) directly to GitHub.
  Future<bool> commitFileContent({
    required String repo,
    required String branch,
    required String path,
    required String content,
    required String commitMessage,
  }) async {
    final token = await _getToken();

    // Check if the file already exists on GitHub to obtain its SHA
    String? currentSha;
    try {
      final getResp = await http.get(
        Uri.parse('https://api.github.com/repos/$repo/contents/$path?ref=$branch'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.github.v3+json',
        },
      ).timeout(const Duration(seconds: 10));

      if (getResp.statusCode == 200) {
        final data = jsonDecode(getResp.body);
        currentSha = data['sha']?.toString();
      }
    } catch (_) {}

    final body = <String, dynamic>{
      'message': commitMessage,
      'content': base64Encode(utf8.encode(content)),
      'branch': branch,
    };
    if (currentSha != null) {
      body['sha'] = currentSha;
    }

    final putResp = await http.put(
      Uri.parse('https://api.github.com/repos/$repo/contents/$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    if (putResp.statusCode == 200 || putResp.statusCode == 201) {
      return true;
    } else {
      debugPrint("GitHub Commit Error (${putResp.statusCode}): ${putResp.body}");
      throw Exception("Failed to commit to GitHub (${putResp.statusCode}): ${putResp.body}");
    }
  }
}
