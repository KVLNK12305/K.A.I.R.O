import 'package:isar/isar.dart';

part 'financial_event.g.dart';

enum FinancialEventType {
  inflow,
  outflow,
  transfer,
  investment,
}

@collection
class FinancialEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  @enumerated
  FinancialEventType type = FinancialEventType.outflow;

  double amount = 0.0;
  String currency = 'INR';

  @Index()
  String category = 'General';

  String merchantOrEntity = '';
  int? sourceAccountId;
  int? destinationAccountId;

  String notes = '';
  bool isRecurring = false;

  int? rawTransactionId;
  @Index()
  String? referenceNumber;
  String source = 'manual';
  String confidence = 'observed';

  FinancialEvent();
}
