import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  String? name;
  
  // Demographics required for Hostile AI algorithms
  double baseHourlyRate;
  String coreIdentity;
  int age;

  DateTime lastUpdated = DateTime.now();

  UserProfile({
    this.name,
    this.baseHourlyRate = 0.0,
    this.coreIdentity = '',
    this.age = 0,
  });
}
