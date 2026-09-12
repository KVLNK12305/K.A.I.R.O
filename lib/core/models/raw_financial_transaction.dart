import 'package:isar/isar.dart';

part 'raw_financial_transaction.g.dart';

@collection
class RawFinancialTransaction {
  Id id = Isar.autoIncrement;

  @Index()
  late String source; // 'android_notification', 'csv_import', 'kairo_node', 'manual'

  @Index()
  String? sourceTransactionId;

  @Index()
  late String fingerprint;

  @Index()
  late DateTime timestamp;

  double amount = 0.0;
  String currency = 'INR';

  String rawTitle = '';
  String rawBody = '';
  String rawMerchant = '';
  String paymentMethod = ''; // 'UPI', 'CARD', 'NETBANKING', 'CASH', 'UNKNOWN'
  String? sourceAccountHint; // 'XX1234', 'HDFC Bank'

  @Index()
  String? referenceNumber; // UTR, UPI Ref, Bank Ref

  late DateTime ingestedAt;
  String rawPayload = '';

  bool isResolved = false;
  int? resolvedFinancialEventId;

  RawFinancialTransaction();
}
