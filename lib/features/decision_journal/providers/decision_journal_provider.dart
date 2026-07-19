import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../main.dart';
import '../../../../core/models/decision_log.dart';
import '../../../../core/services/graph_service.dart';

class DecisionJournalNotifier extends StateNotifier<AsyncValue<List<DecisionLog>>> {
  final Isar isar;

  DecisionJournalNotifier(this.isar) : super(const AsyncValue.loading()) {
    loadDecisions();
  }

  Future<void> loadDecisions() async {
    try {
      final list = await isar.decisionLogs.where().sortByMadeAtDesc().findAll();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addDecision({
    required String title,
    required String contextDescription,
    required String expectedOutcome,
    required int confidenceScore,
    required String emotionalState,
    required int reviewDays,
  }) async {
    final now = DateTime.now();
    final log = DecisionLog()
      ..title = title
      ..contextDescription = contextDescription
      ..expectedOutcome = expectedOutcome
      ..confidenceScore = confidenceScore
      ..emotionalState = emotionalState
      ..madeAt = now
      ..reviewDate = now.add(Duration(days: reviewDays))
      ..verdict = 'Pending';

    await isar.writeTxn(() async {
      await isar.decisionLogs.put(log);
    });

    // Also auto-link in Memory Graph if relevant title matches exist
    final graph = GraphService(isar);
    await graph.createEdge(
      sourceCollection: 'DecisionLog',
      sourceId: log.id,
      sourceTitle: log.title,
      targetCollection: 'System',
      targetId: 1,
      targetTitle: 'Decision Journal Pipeline',
      relationType: 'logged_decision',
    );

    await loadDecisions();
  }

  Future<void> reviewDecision({
    required int id,
    required String actualOutcome,
    required String verdict,
  }) async {
    await isar.writeTxn(() async {
      final log = await isar.decisionLogs.get(id);
      if (log != null) {
        log.actualOutcome = actualOutcome;
        log.verdict = verdict;
        await isar.decisionLogs.put(log);
      }
    });

    await loadDecisions();
  }

  Future<void> deleteDecision(int id) async {
    await isar.writeTxn(() async {
      await isar.decisionLogs.delete(id);
    });
    await loadDecisions();
  }
}

final decisionJournalProvider = StateNotifierProvider<DecisionJournalNotifier, AsyncValue<List<DecisionLog>>>((ref) {
  return DecisionJournalNotifier(isar);
});
