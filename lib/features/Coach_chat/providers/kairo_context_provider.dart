import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../../core/services/kairo_context_service.dart';
import '../../energy_economy/energy_provider.dart';
import '../../energy_economy/providers/time_audit_provider.dart';
import '../../dashboard/providers/wakatime_provider.dart';
import '../../dashboard/providers/finance_provider.dart';

final kairoContextServiceProvider = Provider<KairoContextService>((ref) {
  return KairoContextService(isar);
});

final kairoDossierProvider = FutureProvider.autoDispose<SystemicDossier>((ref) async {
  final service = ref.watch(kairoContextServiceProvider);
  final energyState = ref.watch(energyEconomyProvider);
  final wakatimeVal = ref.watch(wakatimeProvider).valueOrNull ?? 'N/A';
  final financeVal = ref.watch(financeMetricsProvider).valueOrNull;
  final timeAuditVal = ref.watch(timeAuditProvider).valueOrNull;

  return await service.buildSystemicDossier(
    timeAudit: timeAuditVal,
    peak1Tasks: energyState.peak1Tasks,
    peak2Tasks: energyState.peak2Tasks,
    dominantEtiology: energyState.dominantEtiology,
    todayExpense: financeVal?.todayExpense,
    wakatimeStats: wakatimeVal,
  );
});

final kairoFormattedPromptProvider = FutureProvider.autoDispose<String>((ref) async {
  final dossier = await ref.watch(kairoDossierProvider.future);
  return dossier.toFormattedPromptContext();
});
