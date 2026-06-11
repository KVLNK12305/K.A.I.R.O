import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MsTodoTask {
  final String id;
  final String title;
  final bool isCompleted;

  MsTodoTask({required this.id, required this.title, required this.isCompleted});

  factory MsTodoTask.fromJson(Map<String, dynamic> json) {
    return MsTodoTask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['status'] == 'completed',
    );
  }
}

class MsTodoState {
  final List<MsTodoTask> tasks;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const MsTodoState({
    this.tasks = const [],
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  MsTodoState copyWith({
    List<MsTodoTask>? tasks,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return MsTodoState(
      tasks: tasks ?? this.tasks,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MsTodoNotifier extends StateNotifier<MsTodoState> {
  // ─── CONFIGURATION ───
  // Replace with your actual Azure Client ID
  static const String _clientId = 'YOUR_AZURE_CLIENT_ID';
  static const String _tenantId = 'common';
  static const String _redirectUri = 'msauth://com.kairo.app/callback';
  // ─────────────────────

  // Toggle this to test UI without real Azure App
  static const bool _useMockData = true;

  String? _accessToken;

  MsTodoNotifier() : super(const MsTodoState()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('ms_todo_token');
    
    if (_useMockData) {
      state = state.copyWith(isAuthenticated: true);
      await fetchTasks();
    } else if (_accessToken != null) {
      state = state.copyWith(isAuthenticated: true);
      await fetchTasks();
    }
  }

  Future<void> login() async {
    if (_useMockData) {
      state = state.copyWith(isAuthenticated: true);
      await fetchTasks();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final authUrl = Uri.parse(
          'https://login.microsoftonline.com/$_tenantId/oauth2/v2.0/authorize?'
          'client_id=$_clientId&response_type=token&redirect_uri=$_redirectUri&'
          'scope=Tasks.ReadWrite User.Read');
          
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
        // Note: Real OAuth flow requires intercepting the redirect URI.
        // For production, use flutter_appauth or intercept uni_links.
      } else {
        throw Exception('Could not launch Microsoft login.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setMockToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ms_todo_token', token);
    _accessToken = token;
    state = state.copyWith(isAuthenticated: true);
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true, error: null);

    if (_useMockData) {
      await Future.delayed(const Duration(seconds: 1)); // simulate network
      final mockTasks = [
        MsTodoTask(id: '1', title: 'Write architecture document', isCompleted: false),
        MsTodoTask(id: '2', title: 'Email investors', isCompleted: false),
        MsTodoTask(id: '3', title: 'Review Q3 metrics', isCompleted: false),
        MsTodoTask(id: '4', title: 'Schedule offsite', isCompleted: false),
      ];
      state = state.copyWith(tasks: mockTasks, isLoading: false);
      return;
    }

    try {
      // 1. Get default list ID
      final listRes = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      
      if (listRes.statusCode != 200) throw Exception('Failed to fetch To-Do lists');
      final listData = json.decode(listRes.body);
      final defaultListId = listData['value'][0]['id']; // Grabs first list

      // 2. Get tasks from list
      final tasksRes = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$defaultListId/tasks?\$filter=status ne \'completed\''),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (tasksRes.statusCode != 200) throw Exception('Failed to fetch tasks');
      final tasksData = json.decode(tasksRes.body);
      
      final tasks = (tasksData['value'] as List)
          .map((t) => MsTodoTask.fromJson(t))
          .toList();

      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final msTodoProvider = StateNotifierProvider<MsTodoNotifier, MsTodoState>((ref) {
  return MsTodoNotifier();
});
