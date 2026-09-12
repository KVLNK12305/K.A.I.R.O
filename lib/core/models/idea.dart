import 'package:isar/isar.dart';

part 'idea.g.dart';

@collection
class Idea {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;

  String status = 'Parked'; // 'Parked', 'Incubating', 'Promoted', 'Discarded'
  String parkingReason = 'No active commitment requires this yet.';
  DateTime? reviewAfter;

  DateTime createdAt = DateTime.now();

  Idea({
    required this.title,
    required this.content,
    this.status = 'Parked',
    this.parkingReason = 'No active commitment requires this yet.',
    this.reviewAfter,
  });

  Idea.empty();
}

