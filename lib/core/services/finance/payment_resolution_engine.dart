import 'package:isar/isar.dart';
import '../../models/financial_event.dart';
import '../../models/raw_financial_transaction.dart';
import '../../models/account.dart';
import 'payment_ingestion_adapter.dart';

class PaymentResolutionEngine {
  final Isar isar;

  PaymentResolutionEngine(this.isar);

  /// Computes a deterministic deduplication fingerprint.
  /// Rounds timestamp to a 15-minute bucket so near-simultaneous notifications/SMS
  /// for the same transaction match, while separate purchases throughout the day remain unique.
  static String computeFingerprint({
    required double amount,
    required DateTime timestamp,
    required String merchant,
    String? referenceNumber,
    String? accountHint,
  }) {
    if (referenceNumber != null && referenceNumber.trim().isNotEmpty) {
      return 'ref:${referenceNumber.trim().toUpperCase()}';
    }

    final bucketMinute = (timestamp.minute ~/ 15) * 15;
    final bucketDate = DateTime(timestamp.year, timestamp.month, timestamp.day, timestamp.hour, bucketMinute);
    final normMerchant = normalizeMerchant(merchant).toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final normAmount = amount.toStringAsFixed(2);
    final normAcct = accountHint?.trim().toLowerCase() ?? '';

    final raw = '$normAmount|$bucketDate|$normMerchant|$normAcct';
    // FNV-1a 64-bit deterministic hash
    int hash = 0xcbf29ce484222325;
    for (final unit in raw.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x100000001b3) & 0x7FFFFFFFFFFFFFFF;
    }
    return 'fp_${hash.toRadixString(16).padLeft(16, '0')}';
  }

  /// Ingests and resolves a batch of raw transactions.
  Future<IngestionResult> resolveBatch(
    List<RawFinancialTransaction> rawTransactions, {
    required String sourceName,
    int initialIgnoredCount = 0,
    List<String> initialErrors = const [],
  }) async {
    int persisted = 0;
    int duplicates = 0;
    int resolved = 0;
    int ignored = initialIgnoredCount;
    final errors = List<String>.from(initialErrors);

    for (final raw in rawTransactions) {
      try {
        final outcome = await resolveSingle(raw);
        if (outcome == ResolutionOutcome.persistedAndResolved) {
          persisted++;
          resolved++;
        } else if (outcome == ResolutionOutcome.duplicateSkipped) {
          persisted++;
          duplicates++;
        } else {
          ignored++;
        }
      } catch (e) {
        ignored++;
        errors.add('Failed to resolve transaction: $e');
      }
    }

    return IngestionResult(
      source: sourceName,
      totalReceived: rawTransactions.length + initialIgnoredCount,
      newPersisted: persisted,
      duplicatesSkipped: duplicates,
      resolvedEventsCreated: resolved,
      ignoredOrFailed: ignored,
      errorMessages: errors,
    );
  }

  /// Ingests and resolves a single raw transaction.
  Future<ResolutionOutcome> resolveSingle(RawFinancialTransaction raw) async {
    if (raw.amount <= 0) {
      return ResolutionOutcome.ignored;
    }

    // 1. Ensure fingerprint is populated
    if (raw.fingerprint.isEmpty) {
      raw.fingerprint = computeFingerprint(
        amount: raw.amount,
        timestamp: raw.timestamp,
        merchant: raw.rawMerchant.isNotEmpty ? raw.rawMerchant : raw.rawTitle,
        referenceNumber: raw.referenceNumber,
        accountHint: raw.sourceAccountHint,
      );
    }

    // 2. Check for duplicates in Isar
    final isDuplicate = await _isDuplicate(raw);
    if (isDuplicate) {
      raw.isResolved = false;
      await isar.writeTxn(() async {
        await isar.rawFinancialTransactions.put(raw);
      });
      return ResolutionOutcome.duplicateSkipped;
    }

    // 3. Classify event type and category
    final classification = _classify(raw);

    // 4. Resolve Account if hint provided
    Account? matchedAccount;
    if (raw.sourceAccountHint != null && raw.sourceAccountHint!.isNotEmpty) {
      matchedAccount = await _matchAccount(raw.sourceAccountHint!);
    }

    // 5. Persist RawFinancialTransaction and FinancialEvent atomically
    await isar.writeTxn(() async {
      await isar.rawFinancialTransactions.put(raw);

      final event = FinancialEvent()
        ..amount = raw.amount
        ..currency = raw.currency
        ..type = classification.type
        ..category = classification.category
        ..merchantOrEntity = classification.normalizedMerchant
        ..sourceAccountId = matchedAccount?.id
        ..notes = raw.rawBody.isNotEmpty ? raw.rawBody : raw.rawTitle
        ..timestamp = raw.timestamp
        ..rawTransactionId = raw.id
        ..referenceNumber = raw.referenceNumber
        ..source = raw.source
        ..confidence = classification.isInferred ? 'inferred' : 'observed';

      await isar.financialEvents.put(event);

      // Link raw transaction back to the event
      raw.isResolved = true;
      raw.resolvedFinancialEventId = event.id;
      await isar.rawFinancialTransactions.put(raw);

      // Adjust account balance if linked
      if (matchedAccount != null) {
        if (classification.type == FinancialEventType.outflow ||
            classification.type == FinancialEventType.investment ||
            classification.type == FinancialEventType.transfer) {
          matchedAccount.currentBalance -= raw.amount;
        } else if (classification.type == FinancialEventType.inflow) {
          matchedAccount.currentBalance += raw.amount;
        }
        await isar.accounts.put(matchedAccount);
      }
    });

    return ResolutionOutcome.persistedAndResolved;
  }

  Future<bool> _isDuplicate(RawFinancialTransaction raw) async {
    // Check by reference number first if available
    if (raw.referenceNumber != null && raw.referenceNumber!.isNotEmpty) {
      final existingWithRef = await isar.rawFinancialTransactions
          .filter()
          .referenceNumberEqualTo(raw.referenceNumber!)
          .findFirst();
      if (existingWithRef != null) return true;

      final existingEventWithRef = await isar.financialEvents
          .filter()
          .referenceNumberEqualTo(raw.referenceNumber!)
          .findFirst();
      if (existingEventWithRef != null) return true;
    }

    // Check by fingerprint
    final existingWithFp = await isar.rawFinancialTransactions
        .filter()
        .fingerprintEqualTo(raw.fingerprint)
        .findFirst();
    if (existingWithFp != null) return true;

    return false;
  }

  _ClassificationResult _classify(RawFinancialTransaction raw) {
    final text = '${raw.rawTitle} ${raw.rawBody} ${raw.rawMerchant}'.toLowerCase();

    // 1. Investments (Capital Allocation)
    if (text.contains('invested') ||
        text.contains('investment') ||
        text.contains('mutual fund') ||
        text.contains('sip') ||
        text.contains('zerodha') ||
        text.contains('groww') ||
        text.contains('folio') ||
        text.contains('etf') ||
        text.contains('stocks') ||
        text.contains('broker')) {
      return _ClassificationResult(
        type: FinancialEventType.investment,
        category: 'Investments',
        normalizedMerchant: normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : 'Investment'),
        isInferred: false,
      );
    }

    // 2. Transfers
    if (text.contains('transferred to self') ||
        text.contains('self transfer') ||
        text.contains('sent to self') ||
        text.contains('transfer to a/c') ||
        text.contains('inter-account') ||
        (text.contains('transfer') && text.contains('to') && text.contains('account'))) {
      return _ClassificationResult(
        type: FinancialEventType.transfer,
        category: 'Transfers',
        normalizedMerchant: normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : 'Self Transfer'),
        isInferred: false,
      );
    }

    // 3. Inflow & Refunds
    if (text.contains('refund') || text.contains('cashback') || text.contains('reversal')) {
      return _ClassificationResult(
        type: FinancialEventType.inflow,
        category: 'Refunds',
        normalizedMerchant: normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : 'Refund'),
        isInferred: false,
      );
    }

    if (text.contains('salary') || text.contains('payroll') || text.contains('stipend')) {
      return _ClassificationResult(
        type: FinancialEventType.inflow,
        category: 'Salary',
        normalizedMerchant: normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : 'Salary'),
        isInferred: false,
      );
    }

    if (text.contains('credited') || text.contains('received') || text.contains('deposit')) {
      return _ClassificationResult(
        type: FinancialEventType.inflow,
        category: 'Income',
        normalizedMerchant: normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : 'Income'),
        isInferred: false,
      );
    }

    // 4. Outflow / Consumption Spending
    final normMerchant = normalizeMerchant(raw.rawMerchant.isNotEmpty ? raw.rawMerchant : raw.rawTitle);
    final category = _categorizeMerchant(normMerchant, text);

    return _ClassificationResult(
      type: FinancialEventType.outflow,
      category: category,
      normalizedMerchant: normMerchant.isNotEmpty ? normMerchant : 'General Outflow',
      isInferred: category == 'General',
    );
  }

  static String normalizeMerchant(String raw) {
    var m = raw.trim();
    m = m.replaceAll(RegExp(r'^(?:UPI/|PAYTM-|GPAY-|BIL\*|VPS\*|POS\*|E-COM\*|POS/|NEFT-|IMPS-|\*|\s)+', caseSensitive: false), '');
    m = m.replaceAll(RegExp(r'/[A-Za-z0-9]+$', caseSensitive: false), '');
    m = m.replaceAll(RegExp(r'(?:\.com|\.in|@okaxis|@oksbi|@okhdfcbank|@ibl|@ybl|@icici|@paytm|@upi|@axl|@barodampay)$', caseSensitive: false), '');
    m = m.replaceAll(RegExp(r'\s+(?:Private\s+Limited|Pvt\s+Ltd|Ltd|India|Bangalore|Mumbai|Delhi|Stores?|Online)\b', caseSensitive: false), '');
    m = m.replaceAll(RegExp(r'[-_*/]+'), ' ');
    m = m.trim();

    final lower = m.toLowerCase();
    if (lower.contains('swiggy')) return 'Swiggy';
    if (lower.contains('zomato')) return 'Zomato';
    if (lower.contains('blinkit')) return 'Blinkit';
    if (lower.contains('zepto')) return 'Zepto';
    if (lower.contains('instamart')) return 'Instamart';
    if (lower.contains('bigbasket')) return 'BigBasket';
    if (lower.contains('uber')) return 'Uber';
    if (lower.contains('ola')) return 'Ola';
    if (lower.contains('rapido')) return 'Rapido';
    if (lower.contains('netflix')) return 'Netflix';
    if (lower.contains('spotify')) return 'Spotify';
    if (lower.contains('amazon') || lower.contains('amzn')) return 'Amazon';
    if (lower.contains('flipkart')) return 'Flipkart';
    if (lower.contains('myntra')) return 'Myntra';
    if (lower.contains('zara')) return 'Zara';
    if (lower.contains('zerodha')) return 'Zerodha';
    if (lower.contains('groww')) return 'Groww';
    if (lower.contains('airtel')) return 'Airtel';
    if (lower.contains('jio')) return 'Jio';
    if (lower.contains('irctc')) return 'IRCTC';

    if (m.length > 1) {
      final words = m.split(' ').where((w) => w.isNotEmpty);
      m = words.map((w) {
        if (w.length <= 1) return w.toUpperCase();
        return w[0].toUpperCase() + w.substring(1).toLowerCase();
      }).join(' ');
    }
    return m;
  }

  String _categorizeMerchant(String merchant, String fullText) {
    final combined = '$merchant $fullText'.toLowerCase();

    if (combined.contains('swiggy') ||
        combined.contains('zomato') ||
        combined.contains('mcdonald') ||
        combined.contains('starbucks') ||
        combined.contains('kfc') ||
        combined.contains('domino') ||
        combined.contains('subway') ||
        combined.contains('burger') ||
        combined.contains('pizza') ||
        combined.contains('chaayos') ||
        combined.contains('blinkit') ||
        combined.contains('zepto') ||
        combined.contains('instamart') ||
        combined.contains('bigbasket') ||
        combined.contains('grocery') ||
        combined.contains('restaurant') ||
        combined.contains('dining') ||
        combined.contains('cafe')) {
      return 'Food';
    }

    if (combined.contains('uber') ||
        combined.contains('ola') ||
        combined.contains('rapido') ||
        combined.contains('metro') ||
        combined.contains('petrol') ||
        combined.contains('fuel') ||
        combined.contains('diesel') ||
        combined.contains('shell') ||
        combined.contains('indian oil') ||
        combined.contains('iocl') ||
        combined.contains('hpcl') ||
        combined.contains('bpcl') ||
        combined.contains('fastag') ||
        combined.contains('toll') ||
        combined.contains('irctc') ||
        combined.contains('flight') ||
        combined.contains('airline')) {
      return 'Transport';
    }

    if (combined.contains('netflix') ||
        combined.contains('spotify') ||
        combined.contains('youtube') ||
        combined.contains('prime video') ||
        combined.contains('hotstar') ||
        combined.contains('apple') ||
        combined.contains('github') ||
        combined.contains('chatgpt') ||
        combined.contains('openai') ||
        combined.contains('claude') ||
        combined.contains('midjourney') ||
        combined.contains('aws') ||
        combined.contains('digitalocean')) {
      return 'Subscriptions';
    }

    if (combined.contains('amazon') ||
        combined.contains('flipkart') ||
        combined.contains('myntra') ||
        combined.contains('ajio') ||
        combined.contains('meesho') ||
        combined.contains('nykaa') ||
        combined.contains('zara') ||
        combined.contains('h&m') ||
        combined.contains('uniqlo') ||
        combined.contains('decathlon') ||
        combined.contains('shopping')) {
      return 'Shopping';
    }

    if (combined.contains('electricity') ||
        combined.contains('bescom') ||
        combined.contains('water') ||
        combined.contains('gas') ||
        combined.contains('airtel') ||
        combined.contains('jio') ||
        combined.contains('wifi') ||
        combined.contains('broadband') ||
        combined.contains('bill')) {
      return 'Bills';
    }

    if (combined.contains('cult') ||
        combined.contains('gym') ||
        combined.contains('fitness') ||
        combined.contains('pharmacy') ||
        combined.contains('apollo') ||
        combined.contains('1mg') ||
        combined.contains('pharmeasy') ||
        combined.contains('medplus') ||
        combined.contains('hospital') ||
        combined.contains('clinic')) {
      return 'Health';
    }

    if (combined.contains('bookmyshow') ||
        combined.contains('pvr') ||
        combined.contains('inox') ||
        combined.contains('cinepolis') ||
        combined.contains('movie') ||
        combined.contains('cinema') ||
        combined.contains('steam') ||
        combined.contains('playstation')) {
      return 'Entertainment';
    }

    return 'General';
  }

  Future<Account?> _matchAccount(String hint) async {
    final accounts = await isar.accounts.where().findAll();
    final cleanHint = hint.replaceAll(RegExp(r'[^0-9A-Za-z]'), '').toLowerCase();

    for (final acc in accounts) {
      final accName = acc.name.toLowerCase();
      final institution = acc.institution.toLowerCase();
      if (accName.contains(cleanHint) || institution.contains(cleanHint)) {
        return acc;
      }
    }
    return null;
  }
}

enum ResolutionOutcome {
  persistedAndResolved,
  duplicateSkipped,
  ignored,
}

class _ClassificationResult {
  final FinancialEventType type;
  final String category;
  final String normalizedMerchant;
  final bool isInferred;

  const _ClassificationResult({
    required this.type,
    required this.category,
    required this.normalizedMerchant,
    required this.isInferred,
  });
}
