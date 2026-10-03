import 'package:isar/isar.dart';

part 'need.g.dart';

enum NeedType {
  buy,
  replace,
  repair,
  upgrade,
  research,
  someday,
}

enum NeedStatus {
  considering,
  researching,
  ready,
  waiting,
  bought,
  dropped,
  deferred,
}

enum NeedUrgency {
  low,
  medium,
  high,
  urgent,
}

enum NeedPriority {
  low,
  medium,
  high,
}

@collection
class Need {
  Id id = Isar.autoIncrement;

  late String title;
  String description = '';
  String category = 'Tech'; // Tech, Gear, Home, Health, Apparel, Books, Tooling, etc.

  @enumerated
  NeedType type = NeedType.buy;

  @enumerated
  NeedStatus status = NeedStatus.considering;

  @enumerated
  NeedUrgency urgency = NeedUrgency.medium;

  @enumerated
  NeedPriority priority = NeedPriority.medium;

  double? estimatedCost;
  double? targetBudget;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  DateTime? targetDate;
  DateTime? lastReviewedAt;

  String reason = '';
  String replacementFor = '';
  String currentSolution = '';
  String researchNotes = '';
  List<String> links = [];
  String decision = '';

  // Optional Microsoft To Do / External inbox tracking
  String? externalId;
  String? externalSource;
  bool isExternal = false;

  Need();
}
