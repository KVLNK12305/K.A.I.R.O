import 'package:isar/isar.dart';

part 'idea.g.dart';

@collection
class Idea {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;
  
  DateTime createdAt = DateTime.now();

  Idea({
    required this.title,
    required this.content,
  });
  
  Idea.empty();
}
