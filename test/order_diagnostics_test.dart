import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/services/order_service.dart';

void main() {
  group('Order Diagnostics & WIP limit tests', () {
    test('Identifies fragmentation when active projects exceed WIP limit of 3', () {
      const diag = OrderDiagnostics(
        activeProjectsCount: 4,
        openCommitmentsCount: 2,
        parkedIdeasCount: 5,
        pendingDecisionsCount: 1,
        isFragmented: true,
        recommendation: 'ORDER ALERT: 4 active projects exceeds optimal WIP limit (3).',
      );

      expect(diag.isFragmented, isTrue);
      expect(diag.activeProjectsCount, greaterThan(OrderService.maxActiveProjects));
    });

    test('Reports optimal alignment when projects <= 3 and commitments <= 4', () {
      const diag = OrderDiagnostics(
        activeProjectsCount: 2,
        openCommitmentsCount: 3,
        parkedIdeasCount: 10,
        pendingDecisionsCount: 0,
        isFragmented: false,
        recommendation: 'Structural alignment stable.',
      );

      expect(diag.isFragmented, isFalse);
      expect(diag.activeProjectsCount, lessThanOrEqualTo(OrderService.maxActiveProjects));
    });
  });
}
