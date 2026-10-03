import 'package:isar/isar.dart';

part 'project.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late String status;
  
  DateTime createdAt = DateTime.now();

  // ─── Project DNA Metadata ───
  String? repository; // e.g. 'owner/repo' or local path
  String branch = 'main';
  bool isRegisteredKairo = false;
  String? manifestVersion;
  DateTime? lastSyncedAt;

  List<String> implementedCapabilities = [];
  List<String> partialCapabilities = [];
  List<String> plannedCapabilities = [];
  List<String> blockedCapabilities = [];
  List<String> constraints = [];
  String? decisionsMarkdown;

  String? systemArchitecturePath;
  String? dataFlowArchitecturePath;
  String? deploymentArchitecturePath;
  String? roadmapArchitecturePath;

  Project({
    required this.title,
    required this.description,
    this.status = 'Active',
    this.repository,
    this.branch = 'main',
    this.isRegisteredKairo = false,
  });
  
  Project.empty();
}
