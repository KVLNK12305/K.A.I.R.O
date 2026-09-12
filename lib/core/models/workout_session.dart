import 'package:isar/isar.dart';

part 'workout_session.g.dart';

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startTime;

  DateTime? endTime;

  late String title;
  String splitType = 'Full Body';

  int durationMinutes = 0;
  int perceivedExertion = 7; // RPE 1-10

  List<String> exercisesJson = [];

  double totalVolumeKg = 0.0;

  String notes = '';

  DateTime createdAt = DateTime.now();

  WorkoutSession();
}
