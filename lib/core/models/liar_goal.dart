import 'package:isar/isar.dart';

part 'liar_goal.g.dart';

@collection
class LiarGoal {
  Id id = Isar.autoIncrement;

  /// The name of the goal (e.g., "Land first client").
  String title = '';

  /// The grimy, controllable action (e.g., "Cold emails sent").
  String leadMetricLabel = '';

  /// The desired outcome (e.g., "Revenue earned").
  String lagMetricLabel = '';

  /// The unit of the lead metric (e.g., "emails", "commits", "minutes").
  String leadUnit = '';

  /// The unit of the lag metric (e.g., "USD", "followers", "kg").
  String lagUnit = '';

  /// Historical data points: list of doubles, one per "cycle" (e.g., each week).
  /// Each entry is the cumulative lead metric value for that cycle.
  List<double> leadHistory = [];

  /// Historical data points for the lag metric.
  List<double> lagHistory = [];

  /// Whether the "Liar's Chart" state is currently active.
  /// Triggered when lead is flat but lag entries exist (or lead is rising but lag isn't moving).
  bool liarsChartActive = false;

  /// Accountability partner contact info for the forced webhook notification.
  String accountabilityContact = '';

  DateTime createdAt = DateTime.now();

  LiarGoal();

  /// Returns true if lead metric has been flat (all same value) for the last [cycles] entries.
  bool isLeadFlat({int cycles = 3}) {
    if (leadHistory.length < cycles) return false;
    final recent = leadHistory.sublist(leadHistory.length - cycles);
    return recent.every((v) => v == recent.first);
  }

  /// Returns true if lead is rising but lag is not keeping up.
  bool isLeverDisconnected({int cycles = 3}) {
    if (leadHistory.length < cycles || lagHistory.length < cycles) return false;
    final leadRecent = leadHistory.sublist(leadHistory.length - cycles);
    final lagRecent = lagHistory.sublist(lagHistory.length - cycles);
    final leadGrowing = leadRecent.last > leadRecent.first;
    final lagFlat = lagRecent.last <= lagRecent.first;
    return leadGrowing && lagFlat;
  }
}
