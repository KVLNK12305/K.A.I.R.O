import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/services/ledger_service.dart';

void main() {
  group('168-Hour Ledger Breakdown Tests', () {
    test('Calculates zero-sum allocation correctly', () {
      const breakdown = LedgerBreakdown(
        sleepHours: 52.5,
        maintenanceHours: 14.0,
        calendarHours: 10.0,
        observedFocusHours: 20.0,
        screenTimeHours: 15.0,
        unobservedHours: 71.5,
      );

      expect(breakdown.totalHours, 168.0);
      expect(breakdown.allocatedHours, 52.5 + 14.0 + 10.0 + 20.0);
      expect(breakdown.unobservedHours, 71.5);
      expect(breakdown.allocatedHours + breakdown.unobservedHours, 168.0);
      expect(breakdown.capacityPercent, closeTo((96.5 / 168.0) * 100, 0.1));
    });

    test('Clamps capacity percent to 100% max', () {
      const overload = LedgerBreakdown(
        sleepHours: 60.0,
        maintenanceHours: 20.0,
        calendarHours: 50.0,
        observedFocusHours: 50.0,
        screenTimeHours: 20.0,
        unobservedHours: 0.0,
      );

      expect(overload.capacityPercent, 100.0);
    });
  });
}
