import 'package:isar/isar.dart';

part 'decision_log.g.dart';

@collection
class DecisionLog {
  Id id = Isar.autoIncrement;

  /// The decision title or concise summary (e.g., "Pivot target market to B2B SaaS").
  @Index()
  String title = '';

  /// Background context: facts, pressures, and why this decision is necessary now.
  String contextDescription = '';

  /// What we predict will happen as a result (the hypothesis).
  String expectedOutcome = '';

  /// Confidence score from 1 to 10.
  int confidenceScore = 5;

  /// Dominant emotional state at the time of making this decision (e.g., Anxious, Calculated, Desperate, Inspired).
  String emotionalState = '';

  /// When the decision was logged.
  @Index()
  DateTime madeAt = DateTime.now();

  /// Scheduled review date when actual outcome must be evaluated.
  @Index()
  DateTime reviewDate = DateTime.now().add(const Duration(days: 30));

  /// What actually happened (filled in during review).
  String actualOutcome = '';

  /// The post-mortem verdict: 'Pending', 'Successful', 'Flawed Assumption', or 'Disastrous'.
  @Index()
  String verdict = 'Pending';

  DecisionLog();
}
