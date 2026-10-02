import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/models/financial_event.dart';
import 'package:kairo/core/services/finance/payment_notification_parser.dart';
import 'package:kairo/core/services/finance/payment_resolution_engine.dart';
import 'package:kairo/core/services/finance/csv_payment_adapter.dart';
import 'package:kairo/core/services/financial_ledger_service.dart';

void main() {
  group('Payment Notification Parser Tests', () {
    final parser = PaymentNotificationParser();

    test('Parses valid UPI outflow payment correctly', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.nbu.paisa.user',
        title: 'Google Pay',
        body: 'Paid ₹840 to Swiggy using UPI. Ref: 324123456789',
      );

      expect(info, isNotNull);
      expect(info!.amount, 840.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.status, ParsedPaymentStatus.success);
      expect(info.merchantOrEntity, 'Swiggy');
      expect(info.categoryHint, 'Food');
      expect(info.paymentMethod, 'UPI');
      expect(info.referenceNumber, '324123456789');
    });

    test('Parses salary inflow payment with account hint and reference', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'Bank Alert',
        body: 'Credited: Rs 75,000.00 to A/C XX1234 on 01-Sep-26 by SALARY ACME CORP. Ref 9876543210',
      );

      expect(info, isNotNull);
      expect(info!.amount, 75000.0);
      expect(info.direction, ParsedPaymentDirection.inflow);
      expect(info.categoryHint, 'Salary');
      expect(info.sourceAccountHint, 'XX1234');
      expect(info.referenceNumber, '9876543210');
    });

    test('Parses capital allocation / investment correctly (not spending)', () {
      final info = parser.parse(
        packageName: 'com.phonepe.app',
        title: 'PhonePe',
        body: 'Invested Rs 5,000 in Zerodha Broking Ltd. UPI Ref: 11223344',
      );

      expect(info, isNotNull);
      expect(info!.amount, 5000.0);
      expect(info.direction, ParsedPaymentDirection.investment);
      expect(info.categoryHint, 'Investments');
      expect(info.referenceNumber, '11223344');
    });

    test('Parses inter-account transfer correctly (not spending)', () {
      final info = parser.parse(
        packageName: 'com.hdfcbank.android',
        title: 'HDFC Alert',
        body: 'Transferred Rs. 10,000 from A/C 1234 to SBI account. Self transfer complete.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 10000.0);
      expect(info.direction, ParsedPaymentDirection.transfer);
      expect(info.categoryHint, 'Transfers');
    });

    test('Parses refund correctly', () {
      final info = parser.parse(
        packageName: 'net.one97.paytm',
        title: 'Paytm Refund',
        body: 'Refund of Rs 840.00 processed for your Swiggy order. Credited to A/C XX5678',
      );

      expect(info, isNotNull);
      expect(info!.amount, 840.0);
      expect(info.direction, ParsedPaymentDirection.refund);
      expect(info.categoryHint, 'Refunds');
    });

    test('Identifies failed transactions and marks status as failed', () {
      final info = parser.parse(
        packageName: 'com.phonepe.app',
        title: 'Payment Failed',
        body: 'Transaction of Rs. 840 failed at Swiggy due to incorrect UPI PIN.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 840.0);
      expect(info.status, ParsedPaymentStatus.failed);
      expect(info.categoryHint, 'Failed');
    });

    test('Preserves unknown categories honestly without fabricating tags', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'Bank Alert',
        body: 'Debited: Rs 350.00 from A/C XX9999 to KIOSK_INDORE_88. Ref: 445566',
      );

      expect(info, isNotNull);
      expect(info!.amount, 350.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.categoryHint, 'General');
    });

    test('Parses Credit Card swipe SMS correctly', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'HDFC Bank Alert',
        body: 'Alert: Rs. 3,450.00 spent on your HDFC Bank Credit Card ending 4321 at ZARA on 29-SEP-26. Avl lmt: INR 85,000.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 3450.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.merchantOrEntity, 'Zara');
      expect(info.categoryHint, 'Shopping');
      expect(info.sourceAccountHint, 'XX4321');
    });

    test('Parses ICICI Bank Info BIL format correctly', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'ICICI Bank Alert',
        body: 'Acct XX1234 debited with INR 649.00 on 29-Sep-26. Info: BIL*NETFLIX. Avbl Bal: INR 45,000.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 649.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.merchantOrEntity, 'Netflix');
      expect(info.categoryHint, 'Subscriptions');
      expect(info.sourceAccountHint, 'XX1234');
    });

    test('Parses Axis Bank UPI ref-merchant format correctly', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'Axis Bank Alert',
        body: 'INR 420.00 debited from Axis Bank A/c no. XX9988 on 29-09-26 via UPI: 123456789012-ZOMATO. Bal: INR 8,500.00.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 420.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.merchantOrEntity, 'Zomato');
      expect(info.categoryHint, 'Food');
      expect(info.sourceAccountHint, 'XX9988');
    });

    test('Parses HDFC to VPA format correctly', () {
      final info = parser.parse(
        packageName: 'com.google.android.apps.messaging',
        title: 'HDFC Bank',
        body: 'Dear Customer, INR 380.00 debited from A/C **5678 on 28-SEP-26 to VPA swiggy@hdfcbank (UPI Ref No 987654321098). Avail Bal: INR 12,345.67.',
      );

      expect(info, isNotNull);
      expect(info!.amount, 380.0);
      expect(info.direction, ParsedPaymentDirection.outflow);
      expect(info.merchantOrEntity, 'Swiggy');
      expect(info.categoryHint, 'Food');
      expect(info.sourceAccountHint, 'XX5678');
      expect(info.referenceNumber, '987654321098');
    });

    test('Rejects invalid notifications without financial data', () {
      final info = parser.parse(
        packageName: 'com.whatsapp',
        title: 'Mom',
        body: 'Did you reach home safely?',
      );

      expect(info, isNull);
    });
  });

  group('Deduplication & Fingerprint Tests', () {
    test('Same reference produces identical deduplication fingerprint', () {
      final fp1 = PaymentResolutionEngine.computeFingerprint(
        amount: 840.0,
        timestamp: DateTime(2026, 9, 12, 14, 30),
        merchant: 'Swiggy',
        referenceNumber: 'UPI987654321',
      );

      final fp2 = PaymentResolutionEngine.computeFingerprint(
        amount: 840.0,
        timestamp: DateTime(2026, 9, 12, 14, 32),
        merchant: 'Swiggy Food',
        referenceNumber: 'UPI987654321',
      );

      expect(fp1, fp2);
      expect(fp1, 'ref:UPI987654321');
    });

    test('Cross-source duplicates in same 15-minute window match fingerprint', () {
      final fpNotification = PaymentResolutionEngine.computeFingerprint(
        amount: 1200.0,
        timestamp: DateTime(2026, 9, 12, 10, 5),
        merchant: 'Amazon',
        accountHint: 'XX1234',
      );

      final fpBankSms = PaymentResolutionEngine.computeFingerprint(
        amount: 1200.0,
        timestamp: DateTime(2026, 9, 12, 10, 7),
        merchant: 'Amazon India',
        accountHint: 'XX1234',
      );

      expect(fpNotification, fpBankSms);
    });

    test('Legitimate separate transactions at different times remain distinct', () {
      final fpMorningCoffee = PaymentResolutionEngine.computeFingerprint(
        amount: 250.0,
        timestamp: DateTime(2026, 9, 12, 9, 0),
        merchant: 'Starbucks',
      );

      final fpEveningCoffee = PaymentResolutionEngine.computeFingerprint(
        amount: 250.0,
        timestamp: DateTime(2026, 9, 12, 18, 0),
        merchant: 'Starbucks',
      );

      expect(fpMorningCoffee, isNot(equals(fpEveningCoffee)));
    });
  });

  group('CSV Statement Parsing Tests', () {
    test('Parses RFC 4180 CSV with quotes and commas', () {
      const csv = '''Date,Description,Amount,Type,Ref
2026-09-01,"Swiggy, Bangalore",840.00,Debit,REF001
2026-09-02,"Amazon India",2499.00,Debit,REF002
2026-09-03,"Acme Corp Salary",75000.00,Credit,REF003
''';

      final rows = CsvPaymentAdapter.parseCsvRows(csv);
      expect(rows.length, 4);
      expect(rows[1][1], 'Swiggy, Bangalore');
      expect(rows[1][2], '840.00');
      expect(rows[3][2], '75000.00');
    });

    test('Auto-detects separate Debit and Credit columns', () {
      const csv = '''Date,Narration,Withdrawal,Deposit,UTR
05/09/2026,Uber India,450.00,,UTR111
06/09/2026,Client Payout,,15000.00,UTR222
''';

      final rows = CsvPaymentAdapter.parseCsvRows(csv);
      expect(rows.length, 3);
      expect(rows[1][2], '450.00');
      expect(rows[2][3], '15000.00');
    });
  });

  group('Calendar Month Boundaries & Accounting Semantics', () {
    test('Correctly filters exact calendar month boundaries', () {
      final sep1Start = DateTime(2026, 9, 1, 0, 0, 0);
      final sep30End = DateTime(2026, 9, 30, 23, 59, 59);
      final oct1Start = DateTime(2026, 10, 1, 0, 0, 0);
      final aug31End = DateTime(2026, 8, 31, 23, 59, 59);

      final events = [
        FinancialEvent()
          ..amount = 500.0
          ..type = FinancialEventType.outflow
          ..timestamp = aug31End,
        FinancialEvent()
          ..amount = 1000.0
          ..type = FinancialEventType.outflow
          ..timestamp = sep1Start,
        FinancialEvent()
          ..amount = 2000.0
          ..type = FinancialEventType.outflow
          ..timestamp = DateTime(2026, 9, 15, 12, 0),
        FinancialEvent()
          ..amount = 3000.0
          ..type = FinancialEventType.outflow
          ..timestamp = sep30End,
        FinancialEvent()
          ..amount = 4000.0
          ..type = FinancialEventType.outflow
          ..timestamp = oct1Start,
      ];

      final start = DateTime(2026, 9, 1, 0, 0, 0, 0, 0);
      final end = DateTime(2026, 9 + 1, 0, 23, 59, 59, 999, 999);

      final sepEvents = events.where((e) {
        return !e.timestamp.isBefore(start) && !e.timestamp.isAfter(end);
      }).toList();

      expect(sepEvents.length, 3);
      final totalOutflow = sepEvents.fold(0.0, (sum, e) => sum + e.amount);
      expect(totalOutflow, 6000.0); // 1000 + 2000 + 3000
    });

    test('Transfers and Investments do NOT enter Consumption Spending', () {
      final events = [
        FinancialEvent()
          ..amount = 840.0
          ..type = FinancialEventType.outflow
          ..category = 'Food'
          ..timestamp = DateTime(2026, 9, 10),
        FinancialEvent()
          ..amount = 5000.0
          ..type = FinancialEventType.investment
          ..category = 'Investments'
          ..timestamp = DateTime(2026, 9, 11),
        FinancialEvent()
          ..amount = 10000.0
          ..type = FinancialEventType.transfer
          ..category = 'Transfers'
          ..timestamp = DateTime(2026, 9, 12),
        FinancialEvent()
          ..amount = 50000.0
          ..type = FinancialEventType.inflow
          ..category = 'Salary'
          ..timestamp = DateTime(2026, 9, 1),
      ];

      double outflow = 0.0;
      double inflow = 0.0;
      double capital = 0.0;
      double transfers = 0.0;

      for (final e in events) {
        switch (e.type) {
          case FinancialEventType.outflow:
            outflow += e.amount;
            break;
          case FinancialEventType.inflow:
            inflow += e.amount;
            break;
          case FinancialEventType.investment:
            capital += e.amount;
            break;
          case FinancialEventType.transfer:
            transfers += e.amount;
            break;
        }
      }

      expect(outflow, 840.0, reason: 'Outflow must strictly be actual consumption spending');
      expect(capital, 5000.0, reason: 'Investments must be segregated into capital allocation');
      expect(transfers, 10000.0, reason: 'Transfers must not count as spending or income');
      expect(inflow, 50000.0);
    });

    test('MonthlyFinancialSummary correctly represents empty vs zero states', () {
      final emptySummary = MonthlyFinancialSummary.empty(2026, 9);
      expect(emptySummary.hasData, isFalse);
      expect(emptySummary.totalOutflow, 0.0);
      expect(emptySummary.transactionCount, 0);

      final zeroSpendingSummary = MonthlyFinancialSummary(
        year: 2026,
        month: 9,
        totalInflow: 50000.0,
        totalOutflow: 0.0,
        totalCapitalAllocation: 10000.0,
        totalTransfers: 0.0,
        transactionCount: 2,
        categoryBreakdown: const {},
        events: [
          FinancialEvent()
            ..amount = 50000.0
            ..type = FinancialEventType.inflow
            ..timestamp = DateTime(2026, 9, 1),
          FinancialEvent()
            ..amount = 10000.0
            ..type = FinancialEventType.investment
            ..timestamp = DateTime(2026, 9, 2),
        ],
        hasData: true,
      );

      expect(zeroSpendingSummary.hasData, isTrue);
      expect(zeroSpendingSummary.totalOutflow, 0.0);
      expect(zeroSpendingSummary.netCashFlow, 40000.0);
    });

    test('Year boundary separates December 31 23:59:59 from January 1 00:00:00', () {
      final dec31 = DateTime(2026, 12, 31, 23, 59, 59);
      final jan1 = DateTime(2027, 1, 1, 0, 0, 0);

      final events = [
        FinancialEvent()
          ..amount = 5000.0
          ..type = FinancialEventType.outflow
          ..timestamp = dec31,
        FinancialEvent()
          ..amount = 7000.0
          ..type = FinancialEventType.outflow
          ..timestamp = jan1,
      ];

      final decStart = DateTime(2026, 12, 1, 0, 0, 0, 0, 0);
      final decEnd = DateTime(2026, 12 + 1, 0, 23, 59, 59, 999, 999);

      final decEvents = events.where((e) => !e.timestamp.isBefore(decStart) && !e.timestamp.isAfter(decEnd)).toList();
      expect(decEvents.length, 1);
      expect(decEvents.first.amount, 5000.0);

      final janStart = DateTime(2027, 1, 1, 0, 0, 0, 0, 0);
      final janEnd = DateTime(2027, 1 + 1, 0, 23, 59, 59, 999, 999);

      final janEvents = events.where((e) => !e.timestamp.isBefore(janStart) && !e.timestamp.isAfter(janEnd)).toList();
      expect(janEvents.length, 1);
      expect(janEvents.first.amount, 7000.0);
    });

    test('Merchant normalization properly cleans ugly payment strings', () {
      expect(PaymentResolutionEngine.normalizeMerchant('UPI/XYZFOOD/abc123'), 'Xyzfood');
      expect(PaymentResolutionEngine.normalizeMerchant('PAYTM-XYZSTORE-9282'), 'Xyzstore 9282');
      expect(PaymentResolutionEngine.normalizeMerchant('GOOGLE*YOUTUBE'), 'Google Youtube');
      expect(PaymentResolutionEngine.normalizeMerchant('ZOMATO INDIA PVT LTD'), 'Zomato');
      expect(PaymentResolutionEngine.normalizeMerchant('SWIGGY PRIVATE LIMITED'), 'Swiggy');
    });

    test('Negative and zero amounts are rejected by parser', () {
      final parser = PaymentNotificationParser();
      expect(parser.parse(packageName: 'test', title: 'Alert', body: 'Paid Rs 0 at Shop'), isNull);
      expect(parser.parse(packageName: 'test', title: 'Alert', body: 'Debit Rs -500'), isNull);
    });
  });
}
