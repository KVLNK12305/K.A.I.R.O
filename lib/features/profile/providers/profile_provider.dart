import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_profile.dart';
import 'package:isar/isar.dart';
import '../../../main.dart'; // To access global isar instance

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await isar.userProfiles.where().findFirst();
    if (profile != null) {
      state = profile;
    } else {
      final newProfile = UserProfile();
      await isar.writeTxn(() async {
        await isar.userProfiles.put(newProfile);
      });
      state = newProfile;
    }
  }

  Future<void> updateDemographics({
    String? coreIdentity,
    double? baseHourlyRate,
    int? age,
  }) async {
    final profile = state;
    if (coreIdentity != null) profile.coreIdentity = coreIdentity;
    if (baseHourlyRate != null) profile.baseHourlyRate = baseHourlyRate;
    if (age != null) profile.age = age;
    profile.lastUpdated = DateTime.now();

    await isar.writeTxn(() async {
      await isar.userProfiles.put(profile);
    });

    // Update state to trigger UI rebuild
    state = UserProfile(
      name: profile.name,
      coreIdentity: profile.coreIdentity,
      baseHourlyRate: profile.baseHourlyRate,
      age: profile.age,
    )..id = profile.id;
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
