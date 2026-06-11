import 'package:isar/isar.dart';

part 'psychosomatic_scan.g.dart';

@collection
class PsychosomaticScan {
  Id id = Isar.autoIncrement;

  /// Indexed by date — one scan per day.
  @Index(unique: true, replace: true)
  late DateTime date;

  /// 0–100 slider values for each somatic indicator.
  /// Higher = more tension/disturbance (except Breath Depth, Energy Level, Posture
  /// where higher is better — tracked as "depletion" so higher = better here too
  /// to keep the UI consistent; mapping is done in UI layer).

  int muscleTension = 0;
  int headStomachDisturbance = 0;
  int breathDepth = 0;       // higher = deeper (better)
  int jawClench = 0;
  int posture = 0;           // higher = better
  int energyLevel = 0;       // higher = better
  int skinReaction = 0;

  /// Optional label for what was happening (e.g., a meeting name, task name).
  String contextLabel = '';

  PsychosomaticScan();

  /// Composite stress score (0–100). Higher = more stressed.
  /// Inverts the positive indicators so everything points the same direction.
  double get stressScore {
    final stressors = [
      muscleTension,
      headStomachDisturbance,
      jawClench,
      skinReaction,
      100 - breathDepth,     // shallow breath = high stress
      100 - posture,         // poor posture = high stress
      100 - energyLevel,     // low energy = high stress
    ];
    return stressors.reduce((a, b) => a + b) / stressors.length;
  }
}
