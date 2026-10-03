import 'package:isar/isar.dart';

part 'architecture_drift.g.dart';

@collection
class ArchitectureDrift {
  Id id = Isar.autoIncrement;

  @Index()
  int projectId = 0;

  late String projectTitle;
  late String expected;
  late String observed;
  late String missing;
  late String classification; // PLANNED / NOT IMPLEMENTED, etc.
  String notes = '';

  DateTime detectedAt = DateTime.now();
  bool isAcknowledged = false;

  ArchitectureDrift();
}
