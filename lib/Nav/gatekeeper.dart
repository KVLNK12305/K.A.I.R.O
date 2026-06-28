import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/energy_economy/energy_provider.dart';
import '../features/brutalist_review/brutalist_provider.dart';
import '../features/energy_economy/morning_enforcer_page.dart';
import '../features/brutalist_review/brutalist_review_page.dart';
import '../features/liars_chart/liars_chart_provider.dart';
import '../features/liars_chart/liars_chart_page.dart';
import 'main_scaffold.dart';

class Gatekeeper extends ConsumerWidget {
  const Gatekeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final hour = now.hour;

    // 1. Check Evening Interrogation (18:00 - 23:59)
    if (hour >= 18) {
      final brutalState = ref.watch(brutalistProvider);
      if (!brutalState.isLoading && brutalState.todayReview?.isCompleted != true) {
        // Force Brutalist Review
        return const Scaffold(
          backgroundColor: Colors.black,
          body: BrutalistReviewPage(showBackButton: false),
        );
      }
    }

    // 2. Check Morning Enforcer (05:00 - 12:00)
    if (hour >= 5 && hour < 12) {
      final energyState = ref.watch(energyEconomyProvider);
      if (!energyState.isLoading && !energyState.hasAssignedPeaksToday) {
        return MorningEnforcerPage(
          onPassedGauntlet: () {
            // Trigger rebuild by updating state or just relying on Provider
            // Since it watches energyEconomyProvider, it should rebuild automatically when assigned.
          },
        );
      }
    }

    // 3. Weekly Liar's Confrontation (Sunday)
    if (now.weekday == DateTime.sunday) {
      final liarsState = ref.watch(liarsChartProvider);
      if (!liarsState.isLoading &&
          liarsState.goals.any((g) => g.liarsChartActive)) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: LiarsChartPage(isForced: true),
        );
      }
    }

    // If gauntlet passed, allow entry to the Command Center
    return const MainScaffold();
  }
}
