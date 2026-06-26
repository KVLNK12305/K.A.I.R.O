import 'package:isar/isar.dart';

part 'memory_edge.g.dart';

/// The core connecting tissue of the Life Memory Graph.
/// Represents a directed relationship between two arbitrary entities in the KAIRO ecosystem.
@collection
class MemoryEdge {
  Id id = Isar.autoIncrement;

  /// The Isar Collection name of the source entity (e.g., 'Book', 'Idea', 'Task')
  @Index()
  late String sourceCollection;

  /// The Isar ID of the source entity
  @Index()
  late int sourceId;

  /// The title of the source entity, denormalized for extremely fast graph rendering
  /// without needing to query the source collection directly.
  late String sourceTitle;

  /// The Isar Collection name of the target entity
  @Index()
  late String targetCollection;

  /// The Isar ID of the target entity
  @Index()
  late int targetId;

  /// The title of the target entity
  late String targetTitle;

  /// Semantic relationship (e.g., 'inspired', 'applied_to', 'funded_by', 'references')
  @Index()
  late String relationType;

  DateTime createdAt = DateTime.now();

  MemoryEdge({
    required this.sourceCollection,
    required this.sourceId,
    required this.sourceTitle,
    required this.targetCollection,
    required this.targetId,
    required this.targetTitle,
    required this.relationType,
  });
  
  MemoryEdge.empty(); // for isar generator
}
