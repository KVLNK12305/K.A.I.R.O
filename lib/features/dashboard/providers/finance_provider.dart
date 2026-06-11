import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/finance_service.dart';

final financeServiceProvider = Provider<FinanceService>((ref) {
  return FinanceService();
});

final financeMetricsProvider = FutureProvider<FinanceMetrics>((ref) async {
  final service = ref.watch(financeServiceProvider);
  return await service.getCachedMetrics();
});
