import 'package:isar/isar.dart';

part 'focus_session.g.dart';

@collection
class FocusSession {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startTime;

  DateTime? endTime;

  late String title;

  String? peakTaskId;

  int plannedDurationMinutes = 25;
  int actualDurationMinutes = 0;
  int distractionCount = 0;
  bool completed = false;

  String? notes;

  FocusSession({
    required this.startTime,
    required this.title,
    this.peakTaskId,
    this.plannedDurationMinutes = 25,
    this.actualDurationMinutes = 0,
    this.distractionCount = 0,
    this.completed = false,
    this.endTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'title': title,
        'peakTaskId': peakTaskId,
        'plannedDurationMinutes': plannedDurationMinutes,
        'actualDurationMinutes': actualDurationMinutes,
        'distractionCount': distractionCount,
        'completed': completed,
        'notes': notes,
      };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        startTime: DateTime.parse(json['startTime'] as String),
        title: json['title'] as String? ?? 'Untitled Session',
        peakTaskId: json['peakTaskId'] as String?,
        plannedDurationMinutes: json['plannedDurationMinutes'] as int? ?? 25,
        actualDurationMinutes: json['actualDurationMinutes'] as int? ?? 0,
        distractionCount: json['distractionCount'] as int? ?? 0,
        completed: json['completed'] as bool? ?? false,
        endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
        notes: json['notes'] as String?,
      )..id = json['id'] as int? ?? Isar.autoIncrement;
}
