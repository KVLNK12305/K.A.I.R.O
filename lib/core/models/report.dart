import 'package:isar/isar.dart';

part 'report.g.dart';

enum ReportType {
  daily,
  weekly,
  monthly,
}

@collection
class Report {
  Id id = Isar.autoIncrement;

  @enumerated
  ReportType type = ReportType.weekly;

  @Index()
  late DateTime periodStart;
  late DateTime periodEnd;

  int plannedPeaks = 0;
  int completedPeaks = 0;
  double observedFocusHours = 0.0;
  double observedCalendarHours = 0.0;
  double observedScreenTimeHours = 0.0;
  double totalOutflow = 0.0;
  double totalCapitalInvested = 0.0;

  String mirrorSummary = '';
  String rootCauseDiagnosis = '';
  String recommendedAction = '';

  DateTime generatedAt = DateTime.now();

  Report();
}
