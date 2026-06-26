import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  late String author;
  late String status; // 'Reading', 'Completed', 'Want to Read'
  
  DateTime createdAt = DateTime.now();

  Book({
    required this.title,
    required this.author,
    this.status = 'Want to Read',
  });
  
  Book.empty();
}
