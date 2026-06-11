import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/tasks/v1.dart' as tasks_api;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';

class GoogleApiService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      calendar.CalendarApi.calendarReadonlyScope,
      tasks_api.TasksApi.tasksReadonlyScope,
    ],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    return await _googleSignIn.signInSilently();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<List<calendar.Event>> fetchTodayEvents() async {
    if (currentUser == null) return [];
    
    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return [];

    final calendarApi = calendar.CalendarApi(authClient);
    
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      final events = await calendarApi.events.list(
        'primary',
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        orderBy: 'startTime',
        singleEvents: true,
      );
      return events.items ?? [];
    } catch (e) {
      debugPrint("Error fetching events: $e");
      return [];
    }
  }

  Future<List<tasks_api.Task>> fetchPendingTasks() async {
    if (currentUser == null) return [];

    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return [];

    final tasksApi = tasks_api.TasksApi(authClient);

    try {
      final tasksList = await tasksApi.tasks.list('@default', showCompleted: false);
      return tasksList.items ?? [];
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
      return [];
    }
  }
}
