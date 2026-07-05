import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/google_api_service.dart';
import '../../../core/services/time_audit_service.dart';

final timeAuditProvider = FutureProvider.autoDispose<TimeAuditResult>((ref) async {
  final events = await GoogleApiService().fetchWeeklyEvents();
  return await TimeAuditService().calculateWeeklyAudit(events);
});
