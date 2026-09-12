import 'package:isar/isar.dart';

part 'daily_plan.g.dart';

@collection
class DailyPlan {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  String peak1Title = '';
  String peak1Outcome = '';
  int peak1DurationMinutes = 90;
  bool peak1Completed = false;

  String peak2Title = '';
  String peak2Outcome = '';
  int peak2DurationMinutes = 90;
  bool peak2Completed = false;

  String? nonNegotiableNote;
  DateTime plannedAt = DateTime.now();
  DateTime? reviewedAt;

  DailyPlan();
}
