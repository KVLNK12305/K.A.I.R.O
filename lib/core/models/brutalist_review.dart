import 'package:isar/isar.dart';

part 'brutalist_review.g.dart';

/// Represents the cowardice category selected by the user.
enum CowardiceTag {
  none,
  avoidance,
  dishonesty,
  mutedNeed,
  comfortSeeking,
}

@collection
class BrutalistReview {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  /// The vent/story section — capped at 300 chars in the UI.
  String vent = '';

  /// Single sentence of what actually mattered today.
  String highlight = '';

  /// The self-betrayal category.
  @enumerated
  CowardiceTag cowardiceTag = CowardiceTag.none;

  /// Description of the exact moment of cowardice (if tag != none).
  String cowardiceDescription = '';

  /// Estimated future value (in user's currency) lost to distraction.
  double futureCostLost = 0.0;

  /// Whether the user has completed today's review.
  bool isCompleted = false;

  BrutalistReview();
}
