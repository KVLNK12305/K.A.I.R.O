import 'package:isar/isar.dart';

part 'architecture_artifact.g.dart';

@collection
class ArchitectureArtifact {
  Id id = Isar.autoIncrement;

  @Index()
  int projectId = 0;

  late String projectTitle;
  late String architectureType; // system, data_flow, deployment, roadmap, custom
  late String sourcePath;
  late String rawMermaid;

  List<String> declaredNodes = [];
  List<String> declaredEdges = [];

  DateTime lastSyncedAt = DateTime.now();

  ArchitectureArtifact();
}
