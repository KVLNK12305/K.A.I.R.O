import 'package:isar/isar.dart';
import '../models/memory_edge.dart';

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

  /// Gets the entire global graph (limit in production!).
  Future<List<MemoryEdge>> getGlobalGraph() async {
    return await isar.memoryEdges.where().findAll();
  }
}
