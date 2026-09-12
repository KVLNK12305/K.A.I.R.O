import 'package:isar/isar.dart';

part 'commitment.g.dart';

enum CommitmentStatus {
  active,
  paused,
  completed,
  archived,
}

@collection
class Commitment {
  Id id = Isar.autoIncrement;

  @Index()
  late String title;

  String whyItMatters = '';
  late DateTime targetDeadline;
  String desiredOutcome = '';
  String failureConsequence = '';

  @enumerated
  CommitmentStatus status = CommitmentStatus.active;

  DateTime createdAt = DateTime.now();
  DateTime? completedAt;

  Commitment();
}
