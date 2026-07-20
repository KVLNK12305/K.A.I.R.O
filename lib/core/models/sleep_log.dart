import 'package:isar/isar.dart';

part 'sleep_log.g.dart';

@collection
class SleepLog {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  double hoursSlept = 7.0;
  int qualityRating = 3; // 1 to 5
  String? wakeTime; // e.g. "06:15"
  String? bedTime; // e.g. "23:00"
  String? notes;

  SleepLog({
    required this.date,
    this.hoursSlept = 7.0,
    this.qualityRating = 3,
    this.wakeTime,
    this.bedTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'hoursSlept': hoursSlept,
        'qualityRating': qualityRating,
        'wakeTime': wakeTime,
        'bedTime': bedTime,
        'notes': notes,
      };

  factory SleepLog.fromJson(Map<String, dynamic> json) => SleepLog(
        date: DateTime.parse(json['date'] as String),
        hoursSlept: (json['hoursSlept'] as num?)?.toDouble() ?? 7.0,
        qualityRating: json['qualityRating'] as int? ?? 3,
        wakeTime: json['wakeTime'] as String?,
        bedTime: json['bedTime'] as String?,
        notes: json['notes'] as String?,
      )..id = json['id'] as int? ?? Isar.autoIncrement;
}
