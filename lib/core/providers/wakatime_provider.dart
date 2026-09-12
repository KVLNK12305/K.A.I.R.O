import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wakatime_service.dart';

final wakatimeServiceProvider = Provider<WakaTimeService>((ref) {
  return WakaTimeService();
});

final wakatimeProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(wakatimeServiceProvider);
  return await service.fetchTodayCodingHours();
});
