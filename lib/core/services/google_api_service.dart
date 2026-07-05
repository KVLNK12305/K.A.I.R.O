import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/tasks/v1.dart' as tasks_api;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';

class GoogleApiService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      calendar.CalendarApi.calendarScope,
      tasks_api.TasksApi.tasksScope,
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

  static DateTime getStartOfCurrentWeek() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1)); // Monday 00:00:00
  }

  Future<List<calendar.Event>> fetchWeeklyEvents() async {
    if (currentUser == null) return [];
    
    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return [];

    final calendarApi = calendar.CalendarApi(authClient);
    
    final startOfWeek = getStartOfCurrentWeek();
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    try {
      final events = await calendarApi.events.list(
        'primary',
        timeMin: startOfWeek.toUtc(),
        timeMax: endOfWeek.toUtc(),
        orderBy: 'startTime',
        singleEvents: true,
      );
      return events.items ?? [];
    } catch (e) {
      debugPrint("Error fetching weekly events: $e");
      return [];
    }
  }

  Future<List<calendar.Event>> fetchTomorrowEvents() async {
    if (currentUser == null) return [];
    
    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return [];

    final calendarApi = calendar.CalendarApi(authClient);
    
    final now = DateTime.now();
    final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
    final endOfTomorrow = DateTime(now.year, now.month, now.day + 1, 23, 59, 59);

    try {
      final events = await calendarApi.events.list(
        'primary',
        timeMin: startOfTomorrow.toUtc(),
        timeMax: endOfTomorrow.toUtc(),
        orderBy: 'startTime',
        singleEvents: true,
      );
      return events.items ?? [];
    } catch (e) {
      debugPrint("Error fetching tomorrow events: $e");
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

  Future<bool> createEvent(String title, DateTime start, DateTime end, {String? description, List<String>? recurrence}) async {
    if (currentUser == null) return false;
    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return false;

    final calendarApi = calendar.CalendarApi(authClient);
    final event = calendar.Event(
      summary: title,
      description: description ?? 'Created by K.A.I.R.O Discipline Engine',
      start: calendar.EventDateTime(dateTime: start.toUtc()),
      end: calendar.EventDateTime(dateTime: end.toUtc()),
      recurrence: recurrence,
    );

    try {
      await calendarApi.events.insert(event, 'primary');
      debugPrint("Created Calendar Event: $title");
      return true;
    } catch (e) {
      debugPrint("Error creating calendar event: $e");
      return false;
    }
  }

  Future<bool> createKairoRitualBlocks() async {
    if (currentUser == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final rituals = [
      {
        'title': '🔥 K.A.I.R.O Morning Enforcer',
        'start': today.add(const Duration(hours: 6)),
        'end': today.add(const Duration(hours: 6, minutes: 30)),
        'desc': 'Assign peak energy tasks for the day before entropy takes hold.'
      },
      {
        'title': '⚡ Peak 1 Deep Work',
        'start': today.add(const Duration(hours: 9)),
        'end': today.add(const Duration(hours: 11)),
        'desc': 'Highest cognitive demand block. Zero distractions.'
      },
      {
        'title': '⚡ Peak 2 Deep Work',
        'start': today.add(const Duration(hours: 11)),
        'end': today.add(const Duration(hours: 12, minutes: 30)),
        'desc': 'Second wind execution block.'
      },
      {
        'title': '🧘 Recovery Block',
        'start': today.add(const Duration(hours: 14)),
        'end': today.add(const Duration(hours: 15, minutes: 30)),
        'desc': 'Low-stakes admin and recovery. Protect cognitive bandwidth.'
      },
      {
        'title': '🔪 Evening Interrogation',
        'start': today.add(const Duration(hours: 18)),
        'end': today.add(const Duration(hours: 18, minutes: 30)),
        'desc': 'Brutalist Review: confront the truth of your execution today.'
      },
    ];

    bool allSuccess = true;
    for (final r in rituals) {
      final success = await createEvent(
        r['title'] as String,
        r['start'] as DateTime,
        r['end'] as DateTime,
        description: r['desc'] as String,
        recurrence: ['RRULE:FREQ=DAILY'],
      );
      if (!success) allSuccess = false;
    }
    return allSuccess;
  }

  Future<bool> syncPeakTasksToCalendar(String peak1Title, String peak2Title) async {
    if (currentUser == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final p1Success = await createEvent(
      '⚡ PEAK 1: $peak1Title',
      today.add(const Duration(hours: 9)),
      today.add(const Duration(hours: 11)),
      description: 'K.A.I.R.O Assigned Peak 1 Objective',
    );

    final p2Success = await createEvent(
      '⚡ PEAK 2: $peak2Title',
      today.add(const Duration(hours: 11)),
      today.add(const Duration(hours: 12, minutes: 30)),
      description: 'K.A.I.R.O Assigned Peak 2 Objective',
    );

    return p1Success && p2Success;
  }
}
