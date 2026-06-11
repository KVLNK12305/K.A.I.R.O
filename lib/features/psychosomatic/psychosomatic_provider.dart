import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../main.dart';
import '../../core/models/psychosomatic_scan.dart';
import '../../core/models/task.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class PsychosomaticState {
  final PsychosomaticScan? todayScan;
  final List<PsychosomaticScan> history; // last 14 days
  final CorrelationAlert? activeAlert;
  final bool isLoading;

  const PsychosomaticState({
    this.todayScan,
    this.history = const [],
    this.activeAlert,
    this.isLoading = false,
  });

  PsychosomaticState copyWith({
    PsychosomaticScan? todayScan,
    List<PsychosomaticScan>? history,
    CorrelationAlert? activeAlert,
    bool? isLoading,
  }) {
    return PsychosomaticState(
      todayScan: todayScan ?? this.todayScan,
      history: history ?? this.history,
      activeAlert: activeAlert,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CorrelationAlert {
  final String contextLabel;
  final double avgStressScore;
  final String message;

  const CorrelationAlert({
    required this.contextLabel,
    required this.avgStressScore,
    required this.message,
  });
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class PsychosomaticNotifier extends StateNotifier<PsychosomaticState> {
  PsychosomaticNotifier()
      : super(const PsychosomaticState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Use filter() which is available without generated schema code.
    final allScans = await isar.psychosomaticScans.where().anyId().findAll();

    final todayScan = allScans.where((s) {
      return s.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          s.date.isBefore(endOfDay);
    }).firstOrNull;

    final twoWeeksAgo = today.subtract(const Duration(days: 14));
    final history = allScans
        .where((s) => s.date.isAfter(twoWeeksAgo))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final alert = _computeCorrelationAlert(history);

    state = PsychosomaticState(
      todayScan: todayScan,
      history: history,
      activeAlert: alert,
    );
  }

  Future<void> saveScan({
    required int muscleTension,
    required int headStomachDisturbance,
    required int breathDepth,
    required int jawClench,
    required int posture,
    required int energyLevel,
    required int skinReaction,
    String contextLabel = '',
  }) async {
    final today = DateTime.now();
    final scan = PsychosomaticScan()
      ..date = DateTime(today.year, today.month, today.day)
      ..muscleTension = muscleTension
      ..headStomachDisturbance = headStomachDisturbance
      ..breathDepth = breathDepth
      ..jawClench = jawClench
      ..posture = posture
      ..energyLevel = energyLevel
      ..skinReaction = skinReaction
      ..contextLabel = contextLabel;

    await isar.writeTxn(() async {
      await isar.psychosomaticScans.put(scan);
      
      // The Crucible Generation Logic
      if (contextLabel.isNotEmpty) {
        final all = await isar.psychosomaticScans.where().anyId().findAll();
        final contextScans = all.where((s) => s.contextLabel.toLowerCase() == contextLabel.toLowerCase()).toList();
        
        int highStressCount = 0;
        for (final s in contextScans) {
          // Calculate stress proxy
          final stress = (s.muscleTension + s.headStomachDisturbance + s.jawClench + s.skinReaction + (100 - s.breathDepth) + (100 - s.posture) + (100 - s.energyLevel)) / 7;
          if (stress >= 75.0) {
            highStressCount++;
          }
        }
        
        if (highStressCount >= 3) {
          // Check if crucible task already exists
          final tasks = await isar.tasks.where().anyId().findAll();
          final crucibleTitle = 'CRUCIBLE: Confront or Fire "$contextLabel"';
          if (!tasks.any((t) => t.title == crucibleTitle && !t.isCompleted)) {
            final t = Task(crucibleTitle, 'Crucible')
              ..energySlot = EnergySlot.peak1; // Force into peak energy
            await isar.tasks.put(t);
          }
        }
      }
    });

    await _load();
  }

  /// Looks for a context label that appears in ≥3 scans and consistently
  /// drives stress score above 75%.
  CorrelationAlert? _computeCorrelationAlert(List<PsychosomaticScan> history) {
    final Map<String, List<double>> labelScores = {};

    for (final scan in history) {
      if (scan.contextLabel.isNotEmpty) {
        labelScores.putIfAbsent(scan.contextLabel, () => []);
        labelScores[scan.contextLabel]!.add(scan.stressScore);
      }
    }

    for (final entry in labelScores.entries) {
      if (entry.value.length >= 3) {
        final avg =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
        if (avg >= 75) {
          return CorrelationAlert(
            contextLabel: entry.key,
            avgStressScore: avg,
            message:
                'Every time "${entry.key}" appears, your stress indicators spike to ${avg.toStringAsFixed(0)}%. '
                'This is a physiological response. What are you going to do about it?',
          );
        }
      }
    }
    return null;
  }

  bool get hasScannedToday => state.todayScan != null;
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final psychosomaticProvider =
    StateNotifierProvider<PsychosomaticNotifier, PsychosomaticState>((ref) {
  return PsychosomaticNotifier();
});
