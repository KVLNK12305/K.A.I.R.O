import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/models/need.dart';
import 'package:kairo/core/models/task.dart';
import 'package:kairo/core/services/need_service.dart';
import 'package:kairo/core/services/microsoft_todo_service.dart';

void main() {
  group('Needs System Architecture Tests', () {
    test('Need model instantiates with expected decision matrix fields', () {
      final need = Need()
        ..title = '12–13 inch tablet + stylus'
        ..category = 'Gear'
        ..type = NeedType.buy
        ..urgency = NeedUrgency.medium
        ..status = NeedStatus.considering
        ..estimatedCost = 45000.0
        ..currentSolution = 'Laptop + phone'
        ..reason = 'Handwritten diagrams and review mobility';

      expect(need.title, '12–13 inch tablet + stylus');
      expect(need.category, 'Gear');
      expect(need.type, NeedType.buy);
      expect(need.urgency, NeedUrgency.medium);
      expect(need.status, NeedStatus.considering);
      expect(need.estimatedCost, 45000.0);
      expect(need.currentSolution, 'Laptop + phone');
      expect(need.isExternal, false);
    });

    test('Needs summary calculates statistics for decision support without coercive pressure', () async {
      final service = NeedService();
      final sampleNeeds = [
        Need()
          ..title = 'Badminton racket maintenance'
          ..urgency = NeedUrgency.urgent
          ..status = NeedStatus.considering
          ..estimatedCost = 1500.0,
        Need()
          ..title = 'Tablet + stylus'
          ..urgency = NeedUrgency.medium
          ..status = NeedStatus.considering
          ..estimatedCost = 45000.0,
        Need()
          ..title = 'Laptop'
          ..urgency = NeedUrgency.low
          ..status = NeedStatus.deferred
          ..estimatedCost = 120000.0,
      ];

      final summary = await service.getNeedsSummary(sampleNeeds);

      expect(summary.totalActive, 3);
      expect(summary.estimatedTotalCost, 166500.0);
      expect(summary.highestUrgency?.title, 'Badminton racket maintenance');
      expect(summary.largestPlannedPurchase?.title, 'Laptop');
      expect(summary.deferredCount, 1);

      final text = summary.editorialSummary;
      expect(text, contains('These are your unresolved needs'));
      expect(text, contains('3 active needs'));
      expect(text, contains('Highest urgency: Badminton racket maintenance'));
      expect(text, contains('The user decides if and when to act'));

      // NEVER contains coercive directives
      expect(text.contains('BUY THIS NOW'), false);
    });

    test('Need only becomes an actionable Task when user explicitly promotes it', () async {
      final service = NeedService();

      final need = Need()
        ..title = 'Tablet + stylus'
        ..category = 'Gear'
        ..status = NeedStatus.considering;

      Task? createdTask;

      // Explicit user promotion
      final promotedTask = await service.promoteToTask(
        needId: 1,
        mockNeed: need,
        taskTitle: 'Compare 12–13 inch tablets under ₹50k',
        category: 'Research',
        energySlot: EnergySlot.recovery,
        onTaskCreated: (task) {
          createdTask = task;
        },
      );

      expect(promotedTask.title, 'Compare 12–13 inch tablets under ₹50k');
      expect(promotedTask.category, 'Research');
      expect(promotedTask.energySlot, EnergySlot.recovery);
      expect(createdTask, isNotNull);
      expect(createdTask!.title, 'Compare 12–13 inch tablets under ₹50k');

      // Need status was updated to researching and decision was recorded
      expect(need.status, NeedStatus.researching);
      expect(need.decision, contains('Promoted to Task'));
    });

    test('Microsoft To Do integration uses dedicated list name', () {
      expect(MicrosoftTodoService.dedicatedListName, 'K.A.I.R.O. — NEEDS');
    });
  });
}
