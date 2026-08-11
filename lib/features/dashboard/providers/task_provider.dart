import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';
import '../../../core/models/task.dart';
import '../../../main.dart'; // to access global isar instance
import '../../../core/services/google_api_service.dart';
import '../../profile/providers/auth_provider.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/tasks/v1.dart' as tasks_api;

class DashboardState {
  final List<Task> isarTasks;
  final List<tasks_api.Task> googleTasks;
  final List<calendar.Event> googleEvents;
  final bool isLoading;

  DashboardState({
    this.isarTasks = const [],
    this.googleTasks = const [],
    this.googleEvents = const [],
    this.isLoading = true,
  });

  DashboardState copyWith({
    List<Task>? isarTasks,
    List<tasks_api.Task>? googleTasks,
    List<calendar.Event>? googleEvents,
    bool? isLoading,
  }) {
    return DashboardState(
      isarTasks: isarTasks ?? this.isarTasks,
      googleTasks: googleTasks ?? this.googleTasks,
      googleEvents: googleEvents ?? this.googleEvents,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TaskNotifier extends StateNotifier<DashboardState> {
  final GoogleApiService _googleApi;

  TaskNotifier(this._googleApi) : super(DashboardState()) {
    loadAllData();
    _initIntentListener();
  }

  StreamSubscription<List<SharedMediaFile>>? _intentDataStreamSubscription;

  Future<void> loadAllData() async {
    state = state.copyWith(isLoading: true);
    
    // Load local Isar tasks
    final tasksFromDB = await isar.tasks.where().anyId().findAll();
    
    // Load Google data if authenticated
    List<tasks_api.Task> gTasks = [];
    List<calendar.Event> gEvents = [];
    
    if (_googleApi.currentUser != null) {
      gTasks = await _googleApi.fetchPendingTasks();
      gEvents = await _googleApi.fetchTodayEvents();
    }

    if (!mounted) return;

    state = state.copyWith(
      isarTasks: tasksFromDB,
      googleTasks: gTasks,
      googleEvents: gEvents,
      isLoading: false,
    );
  }

  Future<void> addTaskFromSharedText(String text) async {
    final newTask = Task(text, "AI Suggestion");
    await isar.writeTxn(() async {
      await isar.tasks.put(newTask);
    });
    await loadAllData();
  }

  Future<void> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await loadAllData();
  }

  void _initIntentListener() {
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        addTaskFromSharedText(value.first.path);
      }
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        addTaskFromSharedText(value.first.path);
        ReceiveSharingIntent.instance.reset(); 
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, DashboardState>((ref) {
  // Watch auth provider so that if user logs in/out, the task provider reconstructs
  ref.watch(authProvider);
  return TaskNotifier(ref.read(googleApiServiceProvider));
});
