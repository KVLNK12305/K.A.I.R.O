import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:app_links/app_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class MsTodoList {
  final String id;
  final String name;
  final List<MsTodoTask> tasks;

  MsTodoList({required this.id, required this.name, required this.tasks});
}

class MsTodoState {
  final List<MsTodoList> lists;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const MsTodoState({
    this.lists = const [],
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  MsTodoState copyWith({
    List<MsTodoList>? lists,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return MsTodoState(
      lists: lists ?? this.lists,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MsTodoNotifier extends StateNotifier<MsTodoState> {
  // ─── CONFIGURATION ───
  static String get _clientId => dotenv.env['AZURE_CLIENT_ID'] ?? 'YOUR_AZURE_CLIENT_ID';
  static String get _tenantId => 'consumers';
  static const String _redirectUri = 'msauth://com.kairo.app/callback';
  // ─────────────────────

  static const String _credentialsKey = 'ms_todo_credentials';

  oauth2.Client? _client;
  oauth2.AuthorizationCodeGrant? _grant;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  MsTodoNotifier() : super(const MsTodoState()) {
    _appLinks = AppLinks();
    _init();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _client?.close();
    super.dispose();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final credsJson = prefs.getString(_credentialsKey);

    if (credsJson != null) {
      try {
        final credentials = oauth2.Credentials.fromJson(credsJson);
        _client = oauth2.Client(
          credentials,
          identifier: _clientId,
          onCredentialsRefreshed: _saveCredentials,
        );
        state = state.copyWith(isAuthenticated: true);
        await fetchTasks();
      } catch (e) {
        // Token might be revoked or invalid JSON
        prefs.remove(_credentialsKey);
        state = state.copyWith(isAuthenticated: false, error: 'Session expired. Please log in again.');
      }
    }
  }

  void _saveCredentials(oauth2.Credentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_credentialsKey, credentials.toJson());
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authorizationEndpoint = Uri.parse('https://login.microsoftonline.com/$_tenantId/oauth2/v2.0/authorize');
      final tokenEndpoint = Uri.parse('https://login.microsoftonline.com/$_tenantId/oauth2/v2.0/token');

      // Create an authorization code grant
      _grant = oauth2.AuthorizationCodeGrant(
        _clientId,
        authorizationEndpoint,
        tokenEndpoint,
      );

      var authUrl = _grant!.getAuthorizationUrl(
        Uri.parse(_redirectUri),
        scopes: ['Tasks.ReadWrite', 'User.Read', 'offline_access'],
      );

      // Force Microsoft to show the login screen instead of auto-logging in or using cached identity
      authUrl = authUrl.replace(
        queryParameters: {
          ...authUrl.queryParameters,
          'prompt': 'login',
        },
      );

      // Listen for incoming deep links for the redirect
      _linkSubscription?.cancel();
      _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) async {
        if (uri.toString().startsWith(_redirectUri)) {
          await _handleAuthCallback(uri);
        }
      });

      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Microsoft login.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _handleAuthCallback(Uri uri) async {
    try {
      if (_grant == null) throw Exception('Authorization grant missing');
      
      _client = await _grant!.handleAuthorizationResponse(uri.queryParameters);
      _saveCredentials(_client!.credentials);
      
      _linkSubscription?.cancel();
      _grant = null;

      state = state.copyWith(isAuthenticated: true, isLoading: false, error: null);
      await fetchTasks();
    } catch (e) {
      state = state.copyWith(isAuthenticated: false, isLoading: false, error: 'Login failed: ${e.toString()}');
    }
  }

  Future<void> fetchTasks() async {
    if (_client == null || !state.isAuthenticated) return;
    
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Refresh token is handled automatically by oauth2.Client if needed before making the request.

      // 1. Get ALL lists
      final listRes = await _client!.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists'),
      );
      
      if (listRes.statusCode != 200) {
        throw Exception('Failed to fetch To-Do lists: ${listRes.body}');
      }
      
      final listData = json.decode(listRes.body);
      final rawLists = listData['value'] as List;

      if (rawLists.isEmpty) {
        state = state.copyWith(lists: [], isLoading: false);
        return;
      }

      // 2. Get tasks for EACH list sequentially to avoid Microsoft Graph rate limits (activityLimitReached)
      final allLists = <MsTodoList>[];
      for (final listJson in rawLists) {
        final listId = listJson['id'];
        final listName = listJson['displayName'];

        final tasksRes = await _client!.get(
          Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks?\$filter=status ne \'completed\''),
        );

        if (tasksRes.statusCode != 200) {
           throw Exception('Failed to fetch tasks for list $listName: ${tasksRes.body}');
        }
        final tasksData = json.decode(tasksRes.body);
        
        final tasks = (tasksData['value'] as List)
            .map((t) => MsTodoTask.fromJson(t))
            .toList();

        allLists.add(MsTodoList(id: listId, name: listName, tasks: tasks));
      }

      state = state.copyWith(lists: allLists, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      // Optionally handle specific revoked/expired errors here if auto-refresh fails
    }
  }

  Future<void> createTask(String listId, String title) async {
    if (_client == null || !state.isAuthenticated) return;
    
    // Optimistic update
    final newTask = MsTodoTask(id: 'temp_${DateTime.now().millisecondsSinceEpoch}', title: title, isCompleted: false);
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        return MsTodoList(id: l.id, name: l.name, tasks: [newTask, ...l.tasks]);
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    try {
      final res = await _client!.post(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title}),
      );

      if (res.statusCode != 201) {
        throw Exception('Failed to create task: ${res.body}');
      }
      // Replace temp task with real task
      final realTask = MsTodoTask.fromJson(json.decode(res.body));
      final finalLists = state.lists.map((l) {
        if (l.id == listId) {
          final newTasks = l.tasks.map((t) => t.id == newTask.id ? realTask : t).toList();
          return MsTodoList(id: l.id, name: l.name, tasks: newTasks);
        }
        return l;
      }).toList();
      state = state.copyWith(lists: finalLists);
    } catch (e) {
      // Revert optimistic update on failure
      await fetchTasks();
    }
  }

  Future<void> completeTask(String listId, String taskId) async {
    if (_client == null || !state.isAuthenticated) return;

    // Optimistic remove
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        return MsTodoList(id: l.id, name: l.name, tasks: l.tasks.where((t) => t.id != taskId).toList());
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    try {
      final res = await _client!.patch(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': 'completed'}),
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to complete task: ${res.body}');
      }
    } catch (e) {
      await fetchTasks();
    }
  }

  Future<void> deleteTask(String listId, String taskId) async {
    if (_client == null || !state.isAuthenticated) return;

    // Optimistic remove
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        return MsTodoList(id: l.id, name: l.name, tasks: l.tasks.where((t) => t.id != taskId).toList());
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    try {
      final res = await _client!.delete(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId'),
      );

      if (res.statusCode != 204) {
        throw Exception('Failed to delete task: ${res.body}');
      }
    } catch (e) {
      await fetchTasks();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
    _client?.close();
    _client = null;
    state = const MsTodoState();
  }
}

final msTodoProvider = StateNotifierProvider<MsTodoNotifier, MsTodoState>((ref) {
  return MsTodoNotifier();
});
