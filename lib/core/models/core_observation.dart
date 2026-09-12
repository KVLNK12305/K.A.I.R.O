import 'package:isar/isar.dart';

part 'core_observation.g.dart';

enum ObservationType {
  screenTimeSample,
  deviceSleepInferred,
  calendarSync,
  gitCommitSample,
  wakaTimeSample,
  financialExpense,
}

@collection
class CoreObservation {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  @enumerated
  ObservationType type = ObservationType.screenTimeSample;

  String source = 'android_system';
  String dataPayloadJson = '{}';
  int confidence = 100; // 100 = verified fact, 70 = inferred, 50 = estimated

  CoreObservation();
}
