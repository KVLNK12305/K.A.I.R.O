import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:app_links/app_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../energy_economy/energy_provider.dart';

class MsTodoSubTask {
  final String id;
  final String title;
  final bool isChecked;

  MsTodoSubTask({
    required this.id,
    required this.title,
    this.isChecked = false,
  });

  factory MsTodoSubTask.fromJson(Map<String, dynamic> json) {
    return MsTodoSubTask(
      id: json['id']?.toString() ?? '',
      title: (json['displayName'] ?? json['title'] ?? '').toString(),
      isChecked: json['isChecked'] == true || json['status'] == 'completed',
    );
  }

  MsTodoSubTask copyWith({String? id, String? title, bool? isChecked}) {
    return MsTodoSubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class MsTodoTask {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? reminderDateTime;
  final bool isReminderOn;
  final String importance; // 'low', 'normal', 'high'
  final String? body;
  final List<MsTodoSubTask> subTasks;

  MsTodoTask({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.dueDate,
    this.reminderDateTime,
    this.isReminderOn = false,
    this.importance = 'normal',
    this.body,
    this.subTasks = const [],
  });

  factory MsTodoTask.fromJson(Map<String, dynamic> json) {
    DateTime? parseDt(dynamic dtJson) {
      if (dtJson == null || dtJson is! Map || dtJson['dateTime'] == null) return null;
      try {
        String dtStr = dtJson['dateTime'].toString();
        if (!dtStr.endsWith('Z') && !dtStr.contains('+') && !dtStr.contains('-', 10)) {
          dtStr += 'Z';
        }
        return DateTime.tryParse(dtStr)?.toLocal();
      } catch (_) {
        return null;
      }
    }

    String? parseBody(dynamic bodyJson) {
      if (bodyJson == null || bodyJson is! Map) return null;
      final content = bodyJson['content']?.toString() ?? '';
      return content.trim().isEmpty ? null : content;
    }

    List<MsTodoSubTask> parseSubTasks(dynamic subJson) {
      if (subJson == null || subJson is! List) return [];
      return subJson
          .whereType<Map<String, dynamic>>()
          .map((item) => MsTodoSubTask.fromJson(item))
          .toList();
    }

    return MsTodoTask(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['status'] == 'completed',
      dueDate: parseDt(json['dueDateTime']),
      reminderDateTime: parseDt(json['reminderDateTime']),
      isReminderOn: json['isReminderOn'] == true,
      importance: (json['importance'] ?? 'normal').toString().toLowerCase(),
      body: parseBody(json['body']),
      subTasks: parseSubTasks(json['checklistItems']),
    );
  }

  MsTodoTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? reminderDateTime,
    bool? isReminderOn,
    String? importance,
    String? body,
    List<MsTodoSubTask>? subTasks,
    bool clearDueDate = false,
    bool clearReminder = false,
    bool clearBody = false,
  }) {
    return MsTodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      reminderDateTime: clearReminder ? null : (reminderDateTime ?? this.reminderDateTime),
      isReminderOn: isReminderOn ?? this.isReminderOn,
      importance: importance ?? this.importance,
      body: clearBody ? null : (body ?? this.body),
      subTasks: subTasks ?? this.subTasks,
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
    bool clearError = false,
  }) {
    return MsTodoState(
      lists: lists ?? this.lists,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MsTodoNotifier extends StateNotifier<MsTodoState> {
  final Ref ref;
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

  MsTodoNotifier(this.ref) : super(const MsTodoState()) {
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
        if (!mounted) return;
        state = state.copyWith(isAuthenticated: false, error: 'Session expired. Please log in again.');
      }
    }
  }

  void _saveCredentials(oauth2.Credentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_credentialsKey, credentials.toJson());
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, clearError: true);
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
      if (!mounted) return;
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

      if (!mounted) return;
      state = state.copyWith(isAuthenticated: true, isLoading: false, clearError: true);
      await fetchTasks();
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isAuthenticated: false, isLoading: false, error: 'Login failed: ${e.toString()}');
    }
  }

  Future<void> fetchTasks() async {
    if (_client == null || !state.isAuthenticated) return;
    
    state = state.copyWith(isLoading: true, clearError: true);

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
        if (!mounted) return;
        state = state.copyWith(lists: [], isLoading: false);
        return;
      }

      // 2. Get tasks for EACH list sequentially to avoid Microsoft Graph rate limits (activityLimitReached)
      final allLists = <MsTodoList>[];
      for (final listJson in rawLists) {
        final listId = listJson['id'];
        final listName = listJson['displayName'];

        final tasksRes = await _client!.get(
          Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks?\$filter=status ne \'completed\'&\$expand=checklistItems'),
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

      if (!mounted) return;
      state = state.copyWith(lists: allLists, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, error: e.toString());
      // Optionally handle specific revoked/expired errors here if auto-refresh fails
    }
  }

  Map<String, dynamic> _buildTaskPayload({
    required String title,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? reminderDateTime,
    bool clearReminder = false,
    bool isReminderOn = false,
    String importance = 'normal',
    String? body,
    bool clearBody = false,
    bool isMyDay = false,
    List<String>? categories,
  }) {
    final map = <String, dynamic>{
      'title': title,
      'importance': importance.toLowerCase(),
    };

    if (dueDate != null) {
      final dateStr = '${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}T00:00:00';
      map['dueDateTime'] = {
        'dateTime': dateStr,
        'timeZone': 'UTC',
      };
    } else if (clearDueDate) {
      map['dueDateTime'] = null;
    }

    if (isMyDay) {
      map['categories'] = ['My Day', 'Peak'];
      map['extensions'] = [
        {
          '@odata.type': 'microsoft.graph.openTypeExtension',
          'extensionName': 'Microsoft.Todo.MyDay',
          'isMyDay': true,
        }
      ];
    } else if (categories != null && categories.isNotEmpty) {
      map['categories'] = categories;
    }

    if (reminderDateTime != null && isReminderOn) {
      map['reminderDateTime'] = {
        'dateTime': reminderDateTime.toUtc().toIso8601String().substring(0, 19),
        'timeZone': 'UTC',
      };
      map['isReminderOn'] = true;
    } else if (clearReminder || !isReminderOn) {
      map['reminderDateTime'] = null;
      map['isReminderOn'] = false;
    }

    if (body != null && body.isNotEmpty) {
      map['body'] = {
        'content': body,
        'contentType': 'text',
      };
    } else if (clearBody) {
      map['body'] = {
        'content': '',
        'contentType': 'text',
      };
    }

    return map;
  }

  Future<void> createTask(
    String listId,
    String title, {
    DateTime? dueDate,
    DateTime? reminderDateTime,
    bool isReminderOn = false,
    String importance = 'normal',
    String? body,
    bool isMyDay = false,
    List<String>? categories,
  }) async {
    if (_client == null || !state.isAuthenticated) return;
    
    // Optimistic update
    final newTask = MsTodoTask(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      isCompleted: false,
      dueDate: dueDate,
      reminderDateTime: reminderDateTime,
      isReminderOn: isReminderOn,
      importance: importance,
      body: body,
    );
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        return MsTodoList(id: l.id, name: l.name, tasks: [newTask, ...l.tasks]);
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    try {
      final payload = _buildTaskPayload(
        title: title,
        dueDate: dueDate,
        reminderDateTime: reminderDateTime,
        isReminderOn: isReminderOn,
        importance: importance,
        body: body,
        isMyDay: isMyDay,
        categories: categories,
      );

      final res = await _client!.post(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
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

  Future<void> updateTask(
    String listId,
    String taskId, {
    required String title,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? reminderDateTime,
    bool clearReminder = false,
    bool isReminderOn = false,
    String importance = 'normal',
    String? body,
    bool clearBody = false,
    bool isMyDay = false,
    List<String>? categories,
  }) async {
    if (_client == null || !state.isAuthenticated) return;

    // Optimistic update
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        final newTasks = l.tasks.map((t) {
          if (t.id == taskId) {
            return t.copyWith(
              title: title,
              dueDate: dueDate,
              clearDueDate: clearDueDate,
              reminderDateTime: reminderDateTime,
              clearReminder: clearReminder,
              isReminderOn: isReminderOn,
              importance: importance,
              body: body,
              clearBody: clearBody,
            );
          }
          return t;
        }).toList();
        return MsTodoList(id: l.id, name: l.name, tasks: newTasks);
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    try {
      final payload = _buildTaskPayload(
        title: title,
        dueDate: dueDate,
        clearDueDate: clearDueDate,
        reminderDateTime: reminderDateTime,
        clearReminder: clearReminder,
        isReminderOn: isReminderOn,
        importance: importance,
        body: body,
        clearBody: clearBody,
        isMyDay: isMyDay,
        categories: categories,
      );

      final res = await _client!.patch(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to update task: ${res.body}');
      }
      final realTask = MsTodoTask.fromJson(json.decode(res.body));
      final finalLists = state.lists.map((l) {
        if (l.id == listId) {
          final newTasks = l.tasks.map((t) => t.id == taskId ? realTask : t).toList();
          return MsTodoList(id: l.id, name: l.name, tasks: newTasks);
        }
        return l;
      }).toList();
      state = state.copyWith(lists: finalLists);
    } catch (e) {
      await fetchTasks();
    }
  }

  Future<void> completeTask(String listId, String taskId) async {
    if (_client == null || !state.isAuthenticated) return;

    // Find task title before removing for sync
    String? taskTitle;
    for (final l in state.lists) {
      if (l.id == listId) {
        for (final t in l.tasks) {
          if (t.id == taskId) {
            taskTitle = t.title;
            break;
          }
        }
      }
    }

    // Optimistic remove
    final updatedLists = state.lists.map((l) {
      if (l.id == listId) {
        return MsTodoList(id: l.id, name: l.name, tasks: l.tasks.where((t) => t.id != taskId).toList());
      }
      return l;
    }).toList();
    state = state.copyWith(lists: updatedLists);

    if (taskTitle != null) {
      try {
        final cleanTitle = taskTitle
            .replaceAll('⚡ PEAK 1: ', '')
            .replaceAll('⚡ PEAK 2: ', '')
            .trim();
        final energyState = ref.read(energyEconomyProvider);
        final allEnergyTasks = [
          ...energyState.peak1Tasks,
          ...energyState.peak2Tasks,
          ...energyState.recoveryTasks,
        ];
        for (final t in allEnergyTasks) {
          if (t.title == cleanTitle ||
              t.title.contains(cleanTitle) ||
              cleanTitle.contains(t.title)) {
            ref.read(energyEconomyProvider.notifier).completeTask(t.id);
          }
        }
      } catch (_) {}
    }

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

  Future<void> addChecklistItem(String listId, String taskId, String displayName) async {
    if (_client == null || !state.isAuthenticated) return;
    try {
      final res = await _client!.post(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId/checklistItems'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'displayName': displayName}),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchTasks();
      }
    } catch (_) {
      await fetchTasks();
    }
  }

  Future<void> toggleChecklistItem(String listId, String taskId, String itemId, bool isChecked) async {
    if (_client == null || !state.isAuthenticated) return;
    try {
      final res = await _client!.patch(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId/checklistItems/$itemId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isChecked': isChecked}),
      );
      if (res.statusCode == 200) {
        await fetchTasks();
      }
    } catch (_) {
      await fetchTasks();
    }
  }

  Future<void> deleteChecklistItem(String listId, String taskId, String itemId) async {
    if (_client == null || !state.isAuthenticated) return;
    try {
      final res = await _client!.delete(
        Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists/$listId/tasks/$taskId/checklistItems/$itemId'),
      );
      if (res.statusCode == 204) {
        await fetchTasks();
      }
    } catch (_) {
      await fetchTasks();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
    _client?.close();
    _client = null;
    if (!mounted) return;
    state = const MsTodoState();
  }
}

final msTodoProvider = StateNotifierProvider<MsTodoNotifier, MsTodoState>((ref) {
  return MsTodoNotifier(ref);
});
