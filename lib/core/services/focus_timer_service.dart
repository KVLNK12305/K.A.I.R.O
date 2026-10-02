import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../main.dart';
import '../models/focus_session.dart';
import 'wellbeing_service.dart';
import 'home_widget_sync_service.dart';

class FocusTimerState {
  final FocusSession? activeSession;
  final int secondsRemaining;
  final bool isRunning;
  final bool isPaused;
  final int distractionCount;

  const FocusTimerState({
    this.activeSession,
    this.secondsRemaining = 0,
    this.isRunning = false,
    this.isPaused = false,
    this.distractionCount = 0,
  });

  FocusTimerState copyWith({
    FocusSession? activeSession,
    int? secondsRemaining,
    bool? isRunning,
    bool? isPaused,
    int? distractionCount,
  }) {
    return FocusTimerState(
      activeSession: activeSession ?? this.activeSession,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      distractionCount: distractionCount ?? this.distractionCount,
    );
  }
}

class FocusTimerController extends StateNotifier<FocusTimerState> with WidgetsBindingObserver {
  final Isar isar;
  Timer? _timer;

  FocusTimerController(this.isar) : super(const FocusTimerState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (this.state.isRunning && !this.state.isPaused && (state == AppLifecycleState.paused || state == AppLifecycleState.inactive)) {
      // App went to background during active focus session -> increment distraction count
      this.state = this.state.copyWith(distractionCount: this.state.distractionCount + 1);
    }
  }

  void startSession(String title, {String? peakTaskId, int durationMinutes = 25}) {
    _timer?.cancel();
    final session = FocusSession(
      startTime: DateTime.now(),
      title: title.isEmpty ? 'Deep Work Block' : title,
      peakTaskId: peakTaskId,
      plannedDurationMinutes: durationMinutes,
    );

    state = FocusTimerState(
      activeSession: session,
      secondsRemaining: durationMinutes * 60,
      isRunning: true,
      isPaused: false,
      distractionCount: 0,
    );

    WellbeingService.setFocusMode(true);
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!state.isRunning || state.isPaused) return;

    if (state.secondsRemaining <= 1) {
      completeSession();
    } else {
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    }
  }

  void pauseSession() {
    if (state.isRunning) {
      state = state.copyWith(isPaused: true);
    }
  }

  void resumeSession() {
    if (state.isRunning && state.isPaused) {
      state = state.copyWith(isPaused: false);
    }
  }

  Future<FocusSession?> completeSession() async {
    _timer?.cancel();
    final session = state.activeSession;
    if (session == null) {
      state = const FocusTimerState();
      return null;
    }

    final totalPlannedSeconds = session.plannedDurationMinutes * 60;
    final elapsedSeconds = totalPlannedSeconds - state.secondsRemaining;
    final actualMinutes = (elapsedSeconds / 60).round();

    session.endTime = DateTime.now();
    session.actualDurationMinutes = actualMinutes > 0 ? actualMinutes : 1;
    session.distractionCount = state.distractionCount;
    session.completed = state.secondsRemaining <= 1;

    await isar.writeTxn(() async {
      await isar.focusSessions.put(session);
    });

    // Update native Android home screen widgets
    HomeWidgetSyncService.syncTaskPulseData();
    HomeWidgetSyncService.syncDailyAuditData();
    HomeWidgetSyncService.syncEnergyArcData();

    WellbeingService.setFocusMode(false);
    state = const FocusTimerState();
    return session;
  }

  void cancelSession() {
    _timer?.cancel();
    WellbeingService.setFocusMode(false);
    state = const FocusTimerState();
  }
}

final focusTimerProvider = StateNotifierProvider<FocusTimerController, FocusTimerState>((ref) {
  return FocusTimerController(isar);
});

class FocusService {
  final Isar isar;
  FocusService(this.isar);

  Future<List<FocusSession>> getTodaySessions() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return await isar.focusSessions.filter().startTimeGreaterThan(startOfDay).findAll();
  }

  Future<List<FocusSession>> getRecentSessions({int limit = 10}) async {
    return await isar.focusSessions.where().sortByStartTimeDesc().limit(limit).findAll();
  }

  Future<double> getTodayTotalFocusHours() async {
    final sessions = await getTodaySessions();
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.actualDurationMinutes);
    return totalMinutes / 60.0;
  }
}
