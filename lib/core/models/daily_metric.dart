import 'package:isar/isar.dart';

part 'daily_metric.g.dart';

@collection
class DailyMetric {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  DateTime date;

  int commitsMade;
  int expensesLogged;
  int studyHours;

  DailyMetric({
    required this.date,
    this.commitsMade = 0,
    this.expensesLogged = 0,
    this.studyHours = 0,
  });
}
