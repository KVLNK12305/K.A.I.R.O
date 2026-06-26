import 'package:isar/isar.dart';

part 'project.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late String status;
  
  DateTime createdAt = DateTime.now();

  Project({
    required this.title,
    required this.description,
    this.status = 'Active',
  });
  
  Project.empty();
}
