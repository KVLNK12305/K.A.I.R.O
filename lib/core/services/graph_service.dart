import 'package:isar/isar.dart';
import '../models/memory_edge.dart';
import '../models/task.dart';
import '../models/liar_goal.dart';
import '../models/idea.dart';
import '../models/decision_log.dart';

class GraphService {
  final Isar isar;

  GraphService(this.isar);

  /// Creates a directed edge from one entity to another.
  Future<void> createEdge({
    required String sourceCollection,
    required int sourceId,
    required String sourceTitle,
    required String targetCollection,
    required int targetId,
    required String targetTitle,
    required String relationType,
  }) async {
    final edge = MemoryEdge(
      sourceCollection: sourceCollection,
      sourceId: sourceId,
      sourceTitle: sourceTitle,
      targetCollection: targetCollection,
      targetId: targetId,
      targetTitle: targetTitle,
      relationType: relationType,
    );

    await isar.writeTxn(() async {
      await isar.memoryEdges.put(edge);
    });
  }

  /// Removes a specific edge.
  Future<void> removeEdge(int edgeId) async {
    await isar.writeTxn(() async {
      await isar.memoryEdges.delete(edgeId);
    });
  }

  /// Gets all edges where the given entity is either the source or target.
  Future<List<MemoryEdge>> getEdgesForNode(String collection, int id) async {
    return await isar.memoryEdges
        .filter()
        .group((q) => q
            .sourceCollectionEqualTo(collection)
            .and()
            .sourceIdEqualTo(id))
        .or()
        .group((q) => q
            .targetCollectionEqualTo(collection)
            .and()
            .targetIdEqualTo(id))
        .findAll();
  }

  /// Gets the global graph with a safety limit to prevent memory bloat.
  Future<List<MemoryEdge>> getGlobalGraph({int limit = 500}) async {
    return await isar.memoryEdges.where().limit(limit).findAll();
  }

  /// Automatically scans chat/coach text for references to entities and synthesizes memory graph edges.
  Future<int> autoSynthesizeEdgesFromChat(String text) async {
    if (text.isEmpty || text.length < 5) return 0;
    final lowerText = text.toLowerCase();
    int newEdgesCount = 0;

    final tasks = await isar.tasks.where().findAll();
    final goals = await isar.liarGoals.where().findAll();
    final ideas = await isar.ideas.where().findAll();
    final decisions = await isar.decisionLogs.where().findAll();

    final foundEntities = <Map<String, dynamic>>[];

    for (final t in tasks) {
      if (t.title.isNotEmpty && lowerText.contains(t.title.toLowerCase()) && t.title.length > 3) {
        foundEntities.add({'collection': 'Task', 'id': t.id, 'title': t.title});
      }
    }
    for (final g in goals) {
      if (g.title.isNotEmpty && lowerText.contains(g.title.toLowerCase()) && g.title.length > 3) {
        foundEntities.add({'collection': 'LiarGoal', 'id': g.id, 'title': g.title});
      }
    }
    for (final i in ideas) {
      if (i.title.isNotEmpty && lowerText.contains(i.title.toLowerCase()) && i.title.length > 3) {
        foundEntities.add({'collection': 'Idea', 'id': i.id, 'title': i.title});
      }
    }
    for (final d in decisions) {
      if (d.title.isNotEmpty && lowerText.contains(d.title.toLowerCase()) && d.title.length > 3) {
        foundEntities.add({'collection': 'DecisionLog', 'id': d.id, 'title': d.title});
      }
    }

    if (foundEntities.length >= 2) {
      for (int i = 0; i < foundEntities.length; i++) {
        for (int j = i + 1; j < foundEntities.length; j++) {
          final source = foundEntities[i];
          final target = foundEntities[j];
          if (source['collection'] == target['collection'] && source['id'] == target['id']) continue;

          final existing = await isar.memoryEdges
              .filter()
              .sourceCollectionEqualTo(source['collection'] as String)
              .sourceIdEqualTo(source['id'] as int)
              .targetCollectionEqualTo(target['collection'] as String)
              .targetIdEqualTo(target['id'] as int)
              .findFirst();

          if (existing == null) {
            await createEdge(
              sourceCollection: source['collection'] as String,
              sourceId: source['id'] as int,
              sourceTitle: source['title'] as String,
              targetCollection: target['collection'] as String,
              targetId: target['id'] as int,
              targetTitle: target['title'] as String,
              relationType: 'ai_synthesized',
            );
            newEdgesCount++;
          }
        }
      }
    }

    return newEdgesCount;
  }
}
