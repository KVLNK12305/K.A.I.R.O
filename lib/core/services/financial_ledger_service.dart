import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/financial_event.dart';
import '../models/account.dart';
import '../../main.dart';
import 'finance/payment_ingestion_adapter.dart';
import 'finance/payment_resolution_engine.dart';
import 'finance/csv_payment_adapter.dart';
import 'finance/android_notification_adapter.dart';
import 'finance/kairo_node_migrator.dart';

class FinancialOverview {
  final double todayBurn;
  final double weekBurn;
  final double monthBurn;
  final double totalInvestedMonth;
  final double totalCashBalance;

  const FinancialOverview({
    required this.todayBurn,
    required this.weekBurn,
    required this.monthBurn,
    required this.totalInvestedMonth,
    required this.totalCashBalance,
  });
}

class MonthlyFinancialSummary {
  final int year;
  final int month;
  final double totalInflow;
  final double totalOutflow; // Strictly actual consumption spending
  final double totalCapitalAllocation; // Strictly investments
  final double totalTransfers; // Strictly inter-account movements
  final int transactionCount;
  final Map<String, double> categoryBreakdown;
  final List<FinancialEvent> events;
  final bool hasData;

  const MonthlyFinancialSummary({
    required this.year,
    required this.month,
    required this.totalInflow,
    required this.totalOutflow,
    required this.totalCapitalAllocation,
    required this.totalTransfers,
    required this.transactionCount,
    required this.categoryBreakdown,
    required this.events,
    required this.hasData,
  });

  double get netCashFlow => totalInflow - totalOutflow - totalCapitalAllocation;

  static MonthlyFinancialSummary empty(int year, int month) {
    return MonthlyFinancialSummary(
      year: year,
      month: month,
      totalInflow: 0.0,
      totalOutflow: 0.0,
      totalCapitalAllocation: 0.0,
      totalTransfers: 0.0,
      transactionCount: 0,
      categoryBreakdown: const {},
      events: const [],
      hasData: false,
    );
  }
}

class FinancialLedgerService {
  final Isar isar;
  late final PaymentResolutionEngine resolutionEngine;

  FinancialLedgerService(this.isar) {
    resolutionEngine = PaymentResolutionEngine(isar);
  }

  Future<void> seedDefaultAccountsIfEmpty() async {
    final count = await isar.accounts.count();
    if (count == 0) {
      await isar.writeTxn(() async {
        await isar.accounts.put(
          Account()
            ..name = 'Primary Bank (Savings)'
            ..type = AccountType.bankSavings
            ..currentBalance = 0.0
            ..institution = 'Bank',
        );
        await isar.accounts.put(
          Account()
            ..name = 'Cash / Physical Wallet'
            ..type = AccountType.cash
            ..currentBalance = 0.0
            ..institution = 'Cash',
        );
        await isar.accounts.put(
          Account()
            ..name = 'Investment Broker / Folio'
            ..type = AccountType.investmentBroker
            ..currentBalance = 0.0
            ..institution = 'Broker',
        );
      });
    }
  }

  Future<FinancialEvent> logTransaction({
    required double amount,
    required FinancialEventType type,
    String category = 'General',
    String merchantOrEntity = '',
    int? sourceAccountId,
    int? destinationAccountId,
    String notes = '',
    DateTime? timestamp,
  }) async {
    final event = FinancialEvent()
      ..amount = amount
      ..type = type
      ..category = category
      ..merchantOrEntity = merchantOrEntity
      ..sourceAccountId = sourceAccountId
      ..destinationAccountId = destinationAccountId
      ..notes = notes
      ..timestamp = timestamp ?? DateTime.now()
      ..source = 'manual'
      ..confidence = 'observed';

    await isar.writeTxn(() async {
      await isar.financialEvents.put(event);

      // Adjust account balance if account ID provided
      if (sourceAccountId != null) {
        final source = await isar.accounts.get(sourceAccountId);
        if (source != null) {
          if (type == FinancialEventType.outflow ||
              type == FinancialEventType.transfer ||
              type == FinancialEventType.investment) {
            source.currentBalance -= amount;
          } else if (type == FinancialEventType.inflow) {
            source.currentBalance += amount;
          }
          await isar.accounts.put(source);
        }
      }

      if (destinationAccountId != null &&
          (type == FinancialEventType.transfer || type == FinancialEventType.investment)) {
        final dest = await isar.accounts.get(destinationAccountId);
        if (dest != null) {
          dest.currentBalance += amount;
          await isar.accounts.put(dest);
        }
      }
    });

    return event;
  }

  /// Deterministic Monthly Aggregation strictly separating consumption spending,
  /// capital allocations (investments), inter-account transfers, and inflows.
  Future<MonthlyFinancialSummary> getMonthlySummary(int year, int month) async {
    final start = DateTime(year, month, 1, 0, 0, 0, 0, 0);
    final end = DateTime(year, month + 1, 0, 23, 59, 59, 999, 999);

    final allEvents = await isar.financialEvents
        .where()
        .sortByTimestampDesc()
        .findAll();

    final monthEvents = allEvents.where((e) {
      return !e.timestamp.isBefore(start) && !e.timestamp.isAfter(end);
    }).toList();

    if (monthEvents.isEmpty) {
      return MonthlyFinancialSummary.empty(year, month);
    }

    double totalInflow = 0.0;
    double totalOutflow = 0.0;
    double totalCapitalAllocation = 0.0;
    double totalTransfers = 0.0;
    final categoryMap = <String, double>{};

    for (final e in monthEvents) {
      switch (e.type) {
        case FinancialEventType.outflow:
          totalOutflow += e.amount;
          final cat = e.category.isNotEmpty ? e.category : 'General';
          categoryMap[cat] = (categoryMap[cat] ?? 0.0) + e.amount;
          break;
        case FinancialEventType.inflow:
          totalInflow += e.amount;
          break;
        case FinancialEventType.investment:
          totalCapitalAllocation += e.amount;
          break;
        case FinancialEventType.transfer:
          totalTransfers += e.amount;
          break;
      }
    }

    return MonthlyFinancialSummary(
      year: year,
      month: month,
      totalInflow: totalInflow,
      totalOutflow: totalOutflow,
      totalCapitalAllocation: totalCapitalAllocation,
      totalTransfers: totalTransfers,
      transactionCount: monthEvents.length,
      categoryBreakdown: categoryMap,
      events: monthEvents,
      hasData: true,
    );
  }

  /// Returns list of distinct calendar months that contain financial events,
  /// sorted chronologically descending. Always includes current month.
  Future<List<DateTime>> getAvailableMonths() async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final events = await isar.financialEvents.where().sortByTimestampDesc().findAll();
    final set = <String, DateTime>{};
    set['${currentMonth.year}-${currentMonth.month}'] = currentMonth;

    for (final e in events) {
      final key = '${e.timestamp.year}-${e.timestamp.month}';
      if (!set.containsKey(key)) {
        set[key] = DateTime(e.timestamp.year, e.timestamp.month);
      }
    }

    final list = set.values.toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  /// Running overview for today/week/month (backward compatible with TodayPage)
  Future<FinancialOverview> getOverview() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    final allEvents = await isar.financialEvents.where().findAll();

    double todayBurn = 0.0;
    double weekBurn = 0.0;
    double monthBurn = 0.0;
    double monthInvested = 0.0;

    for (final e in allEvents) {
      if (e.type == FinancialEventType.outflow) {
        if (!e.timestamp.isBefore(todayStart)) {
          todayBurn += e.amount;
        }
        if (!e.timestamp.isBefore(weekStart)) {
          weekBurn += e.amount;
        }
        if (!e.timestamp.isBefore(monthStart)) {
          monthBurn += e.amount;
        }
      } else if (e.type == FinancialEventType.investment) {
        if (!e.timestamp.isBefore(monthStart)) {
          monthInvested += e.amount;
        }
      }
    }

    final accounts = await isar.accounts.where().findAll();
    double totalCash = 0.0;
    for (final a in accounts) {
      if (a.type == AccountType.bankSavings || a.type == AccountType.cash) {
        totalCash += a.currentBalance;
      }
    }

    return FinancialOverview(
      todayBurn: todayBurn,
      weekBurn: weekBurn,
      monthBurn: monthBurn,
      totalInvestedMonth: monthInvested,
      totalCashBalance: totalCash,
    );
  }

  Future<List<FinancialEvent>> getRecentEvents({int limit = 30}) async {
    return await isar.financialEvents.where().sortByTimestampDesc().limit(limit).findAll();
  }

  Future<List<Account>> getAccounts() async {
    await seedDefaultAccountsIfEmpty();
    return await isar.accounts.where().findAll();
  }

  Future<bool> hasAnyTransactions() async {
    final count = await isar.financialEvents.count();
    return count > 0;
  }

  // --- Ingestion Pipelines ---

  Future<IngestionResult> ingestCsv(String csvContent) async {
    final adapter = CsvPaymentAdapter(
      csvContent: csvContent,
      resolutionEngine: resolutionEngine,
    );
    return await adapter.ingest();
  }

  Future<IngestionResult> syncAndroidNotifications() async {
    final adapter = AndroidNotificationAdapter(
      resolutionEngine: resolutionEngine,
    );
    return await adapter.ingest();
  }

  Future<IngestionResult> migrateKairoNodeIfPresent() async {
    final migrator = KairoNodeMigrator(resolutionEngine);
    return await migrator.ingest();
  }
}

final financialLedgerServiceProvider = Provider<FinancialLedgerService>((ref) {
  return FinancialLedgerService(isar);
});

final financialOverviewProvider = FutureProvider<FinancialOverview>((ref) async {
  final service = ref.watch(financialLedgerServiceProvider);
  return await service.getOverview();
});

final recentFinancialEventsProvider = FutureProvider<List<FinancialEvent>>((ref) async {
  final service = ref.watch(financialLedgerServiceProvider);
  return await service.getRecentEvents();
});

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final monthlySummaryProvider = FutureProvider.family<MonthlyFinancialSummary, DateTime>((ref, month) async {
  final service = ref.watch(financialLedgerServiceProvider);
  return await service.getMonthlySummary(month.year, month.month);
});

final availableMonthsProvider = FutureProvider<List<DateTime>>((ref) async {
  final service = ref.watch(financialLedgerServiceProvider);
  return await service.getAvailableMonths();
});
