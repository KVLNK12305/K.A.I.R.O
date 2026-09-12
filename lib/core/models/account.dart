import 'package:isar/isar.dart';

part 'account.g.dart';

enum AccountType {
  bankSavings,
  creditCard,
  cash,
  investmentBroker,
  mutualFundFolio,
}

@collection
class Account {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  @enumerated
  AccountType type = AccountType.bankSavings;

  double currentBalance = 0.0;
  String institution = '';
  DateTime lastReconciled = DateTime.now();

  Account();
}
