import 'package:isar/isar.dart';

part 'weekly_roulette.g.dart';

@collection
class WeeklyRoulette {
  Id id = Isar.autoIncrement;

  @Index()
  late String topicTitle;
  String category = 'Systems';
  String summary = '';
  String? resourceUrl;

  bool explored = false;
  String? userTakeaway;
  DateTime assignedDate = DateTime.now();

  WeeklyRoulette();
}
