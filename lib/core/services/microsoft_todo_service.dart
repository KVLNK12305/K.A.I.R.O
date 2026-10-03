import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/need.dart';

class MicrosoftTodoService {
  final Isar isar;
  static const String dedicatedListName = "K.A.I.R.O. — NEEDS";

  MicrosoftTodoService(this.isar);

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Check direct token
    final directToken = prefs.getString('ms_todo_token');
    if (directToken != null && directToken.trim().isNotEmpty) {
      return directToken.trim();
    }

    // Check credentials JSON (as seen in test_ms_todo.py)
    final credsJson = prefs.getString('ms_todo_credentials');
    if (credsJson != null && credsJson.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(credsJson);
        if (decoded is Map && decoded['accessToken'] != null) {
          return decoded['accessToken'].toString();
        }
      } catch (e) {
        debugPrint("Error parsing ms_todo_credentials: $e");
      }
    }

    return null;
  }

  /// Sets or updates the Microsoft To Do access token.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ms_todo_token', token.trim());
  }

  /// Finds or creates the dedicated "K.A.I.R.O. — NEEDS" list in Microsoft To Do.
  Future<String?> getOrCreateNeedsList(String accessToken) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // 1. Fetch existing lists
    final listResp = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists'),
      headers: headers,
    ).timeout(const Duration(seconds: 10));

    if (listResp.statusCode != 200) {
      throw Exception('Failed to fetch Microsoft To Do lists: ${listResp.statusCode} - ${listResp.body}');
    }

    final data = jsonDecode(listResp.body);
    final lists = (data['value'] as List<dynamic>?) ?? [];

    for (final lst in lists) {
      final name = (lst['displayName'] ?? '').toString().trim();
      // Match "K.A.I.R.O. — NEEDS" or variations with hyphen/dash
      if (name.toLowerCase() == dedicatedListName.toLowerCase() ||
          name.toLowerCase() == "k.a.i.r.o. - needs" ||
          name.toLowerCase() == "kairo - needs" ||
          name.toLowerCase() == "kairo needs") {
        return lst['id'].toString();
      }
    }

    // 2. Create the list if it doesn't exist
    final createResp = await http.post(
      Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists'),
      headers: headers,
      body: jsonEncode({'displayName': dedicatedListName}),
    ).timeout(const Duration(seconds: 10));

    if (createResp.statusCode == 201 || createResp.statusCode == 200) {
      final createdData = jsonDecode(createResp.body);
      return createdData['id'].toString();
    } else {
      throw Exception('Failed to create Microsoft To Do list: ${createResp.statusCode}');
    }
  }

  /// Ingests items from the dedicated "K.A.I.R.O. — NEEDS" list into the Needs table.
  ///
  /// CRITICAL RULE:
  /// Items from Microsoft To Do MUST NEVER automatically become K.A.I.R.O. daily tasks.
  /// They strictly enter the Needs Inbox for user evaluation and decision.
  Future<List<Need>> syncNeedsFromMicrosoftTodo() async {
    final token = await _getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Microsoft To Do token not configured. Please connect in Settings.');
    }

    final listId = await getOrCreateNeedsList(token);
    if (listId == null) {
      throw Exception('Could not locate or create "$dedicatedListName" list.');
    }

    final tasksResp = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks?\$filter=status ne 'completed'"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (tasksResp.statusCode != 200) {
      throw Exception('Failed to fetch tasks from Microsoft To Do: ${tasksResp.statusCode}');
    }

    final tasksData = jsonDecode(tasksResp.body);
    final items = (tasksData['value'] as List<dynamic>?) ?? [];
    final ingestedNeeds = <Need>[];

    for (final item in items) {
      final id = item['id']?.toString() ?? '';
      final title = (item['title'] ?? '').toString().trim();
      if (id.isEmpty || title.isEmpty) continue;

      // Check if already ingested
      final existing = await isar.needs
          .filter()
          .externalIdEqualTo(id)
          .findFirst();

      if (existing == null) {
        // Infer default type based on keywords
        NeedType inferredType = NeedType.buy;
        final lowerTitle = title.toLowerCase();
        if (lowerTitle.startsWith('replace')) {
          inferredType = NeedType.replace;
        } else if (lowerTitle.startsWith('repair') || lowerTitle.contains('maintenance')) {
          inferredType = NeedType.repair;
        } else if (lowerTitle.startsWith('upgrade')) {
          inferredType = NeedType.upgrade;
        } else if (lowerTitle.startsWith('research') || lowerTitle.startsWith('compare')) {
          inferredType = NeedType.research;
        }

        final bodyContent = item['body']?['content']?.toString() ?? '';

        final need = Need()
          ..title = title
          ..description = bodyContent
          ..category = 'Gear'
          ..type = inferredType
          ..status = NeedStatus.considering
          ..urgency = NeedUrgency.medium
          ..priority = NeedPriority.medium
          ..externalId = id
          ..externalSource = 'ms_todo'
          ..isExternal = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.needs.put(need);
        });

        ingestedNeeds.add(need);
      }
    }

    debugPrint("Microsoft To Do Ingestion: Synced ${ingestedNeeds.length} new needs into K.A.I.R.O. Needs Inbox. (0 tasks created)");
    return ingestedNeeds;
  }
}
