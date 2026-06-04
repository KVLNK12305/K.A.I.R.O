import 'package:isar/isar.dart';

// This tells the generator where to put the background code
part 'task.g.dart'; 

@collection
class Task {
  Id id = Isar.autoIncrement; // Required: gives each task a unique database ID

  String title;
  String category;
  bool isCompleted;

  Task(this.title, this.category, {this.isCompleted = false});
}