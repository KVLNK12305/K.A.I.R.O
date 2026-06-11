import 'package:isar/isar.dart';

part 'crucible_state.g.dart';

/// Tracks whether The Bankruptcy Protocol / Crucible has been triggered.
/// There is only ever one record of this in the DB (id = 1).
@collection
class CrucibleState {
  Id id = 1;

  /// Whether the Crucible is currently active (app locked).
  bool isActive = false;

  /// The "ONE thing" the user committed to.
  String commitment = '';

  /// When the protocol was triggered. 24-hour countdown starts here.
  DateTime? triggeredAt;

  /// When the user submitted proof and unlocked the app.
  DateTime? resolvedAt;

  /// The proof text/path submitted by the user.
  String proofText = '';

  /// How many times the Crucible has been triggered (regression counter).
  int timesTriggered = 0;

  CrucibleState();

  /// Whether the 24h window has expired without proof submission.
  bool get isExpired {
    if (!isActive || triggeredAt == null) return false;
    return DateTime.now().difference(triggeredAt!).inHours >= 24;
  }

  /// Hours remaining before data lock.
  int get hoursRemaining {
    if (!isActive || triggeredAt == null) return 0;
    final elapsed = DateTime.now().difference(triggeredAt!).inHours;
    return (24 - elapsed).clamp(0, 24);
  }
}
