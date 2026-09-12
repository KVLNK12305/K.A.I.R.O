import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/financial_event.dart';
import '../models/account.dart';
import '../../main.dart';

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

class FinancialLedgerService {
  final Isar isar;
  FinancialLedgerService(this.isar);

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
      ..timestamp = timestamp ?? DateTime.now();

    await isar.writeTxn(() async {
      await isar.financialEvents.put(event);

      // Adjust account balance if account ID provided
      if (sourceAccountId != null) {
        final source = await isar.accounts.get(sourceAccountId);
        if (source != null) {
          if (type == FinancialEventType.outflow || type == FinancialEventType.transfer || type == FinancialEventType.investment) {
            source.currentBalance -= amount;
          } else if (type == FinancialEventType.inflow) {
            source.currentBalance += amount;
          }
          await isar.accounts.put(source);
        }
      }

      if (destinationAccountId != null && (type == FinancialEventType.transfer || type == FinancialEventType.investment)) {
        final dest = await isar.accounts.get(destinationAccountId);
        if (dest != null) {
          dest.currentBalance += amount;
          await isar.accounts.put(dest);
        }
      }
    });

    return event;
  }

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
