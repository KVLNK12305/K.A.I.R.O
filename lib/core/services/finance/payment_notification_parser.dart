enum ParsedPaymentStatus {
  success,
  failed,
  pending,
  reversed,
  unknown,
}

enum ParsedPaymentDirection {
  outflow,
  inflow,
  transfer,
  investment,
  refund,
  unknown,
}

class ParsedPaymentInfo {
  final double amount;
  final String currency;
  final ParsedPaymentDirection direction;
  final ParsedPaymentStatus status;
  final String merchantOrEntity;
  final String rawMerchant;
  final String paymentMethod;
  final String? sourceAccountHint;
  final String? destinationAccountHint;
  final String? referenceNumber;
  final String categoryHint;
  final DateTime? timestamp;

  const ParsedPaymentInfo({
    required this.amount,
    this.currency = 'INR',
    required this.direction,
    required this.status,
    required this.merchantOrEntity,
    required this.rawMerchant,
    required this.paymentMethod,
    this.sourceAccountHint,
    this.destinationAccountHint,
    this.referenceNumber,
    required this.categoryHint,
    this.timestamp,
  });
}

class PaymentNotificationParser {
  static final RegExp _amountRegex = RegExp(
    r'(?:(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?))|((?:[\d,]+(?:\.\d{1,2})?)\s*(?:Rs\.?|INR|₹))',
    caseSensitive: false,
  );

  static final RegExp _refRegex = RegExp(
    r'(?:UPI\s*(?:Ref|Txn)?(?:\s*No)?|Ref(?:\s*No)?|UTR|Txn\s*(?:ID|Id|No))[\s:/-]*([A-Za-z0-9]{6,25})',
    caseSensitive: false,
  );

  static final RegExp _accountHintRegex = RegExp(
    r'(?:A/C|Acct|Account|Card(?:\s*ending)?)\s*(?:no\.?)?\s*[*xX]*(\d{3,4})',
    caseSensitive: false,
  );

  static final RegExp _paidToRegex = RegExp(
    r'(?:paid\s+to|sent\s+to|to|at)\s+([A-Za-z0-9\s&.,\-_]+?)(?:\s+(?:using|via|on|from|ref|upi|a/c|card|\.|$))',
    caseSensitive: false,
  );

  static final RegExp _receivedFromRegex = RegExp(
    r'(?:received\s+from|from|by)\s+([A-Za-z0-9\s&.,\-_]+?)(?:\s+(?:on|via|ref|upi|a/c|\.|$))',
    caseSensitive: false,
  );

  ParsedPaymentInfo? parse({
    required String packageName,
    required String title,
    required String body,
    DateTime? timestamp,
  }) {
    final combined = '$title $body'.trim();
    if (combined.isEmpty) return null;

    // 1. Check payment status
    final status = _detectStatus(combined);
    if (status == ParsedPaymentStatus.failed) {
      // Return info marked as failed so ledger can safely record/ignore it
      final amount = _extractAmount(combined);
      if (amount == null) return null;
      return ParsedPaymentInfo(
        amount: amount,
        direction: ParsedPaymentDirection.outflow,
        status: ParsedPaymentStatus.failed,
        merchantOrEntity: _extractRawMerchant(title, body),
        rawMerchant: _extractRawMerchant(title, body),
        paymentMethod: _detectPaymentMethod(packageName, combined),
        categoryHint: 'Failed',
        timestamp: timestamp ?? DateTime.now(),
      );
    }

    // 2. Extract Amount
    final amount = _extractAmount(combined);
    if (amount == null || amount <= 0) {
      return null; // Not a valid financial message
    }

    // 3. Detect Direction
    final direction = _detectDirection(combined);

    // 4. Extract Reference Number
    final refMatch = _refRegex.firstMatch(combined);
    final referenceNumber = refMatch?.group(1)?.trim();

    // 5. Extract Account Hint
    final acctMatch = _accountHintRegex.firstMatch(combined);
    final accountHint = acctMatch != null ? 'XX${acctMatch.group(1)}' : null;

    // 6. Extract Merchant & Normalize
    final rawMerchant = _extractRawMerchant(title, body);
    final normalizedMerchant = _normalizeMerchant(rawMerchant);

    // 7. Detect Payment Method
    final paymentMethod = _detectPaymentMethod(packageName, combined);

    // 8. Classify Category Hint
    final categoryHint = _detectCategory(normalizedMerchant, combined, direction);

    return ParsedPaymentInfo(
      amount: amount,
      direction: direction,
      status: status,
      merchantOrEntity: normalizedMerchant.isNotEmpty ? normalizedMerchant : 'Unknown',
      rawMerchant: rawMerchant,
      paymentMethod: paymentMethod,
      sourceAccountHint: accountHint,
      referenceNumber: referenceNumber,
      categoryHint: categoryHint,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  ParsedPaymentStatus _detectStatus(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('failed') ||
        lower.contains('declined') ||
        lower.contains('unsuccessful') ||
        lower.contains('cancelled') ||
        lower.contains('timed out')) {
      return ParsedPaymentStatus.failed;
    }
    if (lower.contains('pending') || lower.contains('processing')) {
      return ParsedPaymentStatus.pending;
    }
    if (lower.contains('reversed')) {
      return ParsedPaymentStatus.reversed;
    }
    return ParsedPaymentStatus.success;
  }

  ParsedPaymentDirection _detectDirection(String text) {
    final lower = text.toLowerCase();

    // 1. Refunds
    if (lower.contains('refund') || lower.contains('cashback') || lower.contains('reversal')) {
      return ParsedPaymentDirection.refund;
    }

    // 2. Investments & Capital Allocations
    if (lower.contains('invested') ||
        lower.contains('investment') ||
        lower.contains('mutual fund') ||
        lower.contains('sip') ||
        lower.contains('zerodha') ||
        lower.contains('groww') ||
        lower.contains('folio') ||
        lower.contains('etf') ||
        lower.contains('stocks')) {
      return ParsedPaymentDirection.investment;
    }

    // 3. Transfers (self / between accounts)
    if (lower.contains('transferred to self') ||
        lower.contains('self transfer') ||
        lower.contains('sent to self') ||
        lower.contains('own account') ||
        (lower.contains('transferred') && lower.contains('a/c') && lower.contains('to'))) {
      return ParsedPaymentDirection.transfer;
    }

    // 4. Inflows
    if (lower.contains('credited') ||
        lower.contains('received') ||
        lower.contains('salary') ||
        lower.contains('deposited')) {
      return ParsedPaymentDirection.inflow;
    }

    // 5. Outflows
    if (lower.contains('paid') ||
        lower.contains('debited') ||
        lower.contains('sent') ||
        lower.contains('spent') ||
        lower.contains('purchase') ||
        lower.contains('withdrawn')) {
      return ParsedPaymentDirection.outflow;
    }

    return ParsedPaymentDirection.unknown;
  }

  double? _extractAmount(String text) {
    final match = _amountRegex.firstMatch(text);
    if (match == null) return null;

    final rawStr = (match.group(1) ?? match.group(2))?.replaceAll(',', '').trim();
    if (rawStr == null) return null;

    return double.tryParse(rawStr);
  }

  String _detectPaymentMethod(String packageName, String text) {
    final lower = text.toLowerCase();
    final pkg = packageName.toLowerCase();

    if (pkg.contains('paisa') || pkg.contains('upi') || pkg.contains('phonepe') || lower.contains('upi')) {
      return 'UPI';
    }
    if (lower.contains('card') || lower.contains('visa') || lower.contains('mastercard')) {
      return 'CARD';
    }
    if (lower.contains('netbanking') || lower.contains('neft') || lower.contains('rtgs') || lower.contains('imps')) {
      return 'NETBANKING';
    }
    if (lower.contains('wallet') || pkg.contains('paytm')) {
      return 'WALLET';
    }
    return 'UNKNOWN';
  }

  String _extractRawMerchant(String title, String body) {
    // Check "paid to X", "sent to X", "at X"
    final paidMatch = _paidToRegex.firstMatch(body);
    if (paidMatch != null) {
      final m = paidMatch.group(1)?.trim();
      if (m != null && m.length > 1 && !m.toLowerCase().startsWith('rs') && !m.startsWith('₹')) {
        return m;
      }
    }

    // Check "received from X", "from X"
    final recvMatch = _receivedFromRegex.firstMatch(body);
    if (recvMatch != null) {
      final m = recvMatch.group(1)?.trim();
      if (m != null && m.length > 1 && !m.toLowerCase().startsWith('rs') && !m.startsWith('₹')) {
        return m;
      }
    }

    // If body mentions UPI/VPA like UPI/XYZFOOD/Ref
    final upiSlashMatch = RegExp(r'UPI/([A-Za-z0-9_ -]+)/', caseSensitive: false).firstMatch(body);
    if (upiSlashMatch != null) {
      return upiSlashMatch.group(1)!.trim();
    }

    // Fallback to title if title isn't a generic app name
    final cleanedTitle = title.trim();
    final lowerTitle = cleanedTitle.toLowerCase();
    if (cleanedTitle.isNotEmpty &&
        !lowerTitle.contains('payment') &&
        !lowerTitle.contains('transaction') &&
        !lowerTitle.contains('alert') &&
        !lowerTitle.contains('google pay') &&
        !lowerTitle.contains('phonepe') &&
        !lowerTitle.contains('paytm') &&
        !lowerTitle.contains('hdfc') &&
        !lowerTitle.contains('sbi') &&
        !lowerTitle.contains('icici')) {
      return cleanedTitle;
    }

    return '';
  }

  String _normalizeMerchant(String raw) {
    if (raw.isEmpty) return '';

    var clean = raw;
    // Strip common noise prefixes & suffixes
    clean = clean.replaceAll(RegExp(r'^(?:UPI/|PAYTM-|GPAY-|\*|\s)+', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'(?:\.com|\.in|@okaxis|@okhdfcbank|@ibl|@ybl)$', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'\s+Private\s+Limited|\s+Pvt\s+Ltd|\s+Ltd', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'[-_]+'), ' ');
    clean = clean.trim();

    // Capitalize properly
    if (clean.length > 1) {
      final words = clean.split(' ').where((w) => w.isNotEmpty);
      clean = words.map((w) {
        if (w.length <= 1) return w.toUpperCase();
        return w[0].toUpperCase() + w.substring(1).toLowerCase();
      }).join(' ');
    }

    return clean;
  }

  String _detectCategory(String merchant, String text, ParsedPaymentDirection direction) {
    if (direction == ParsedPaymentDirection.investment) return 'Investments';
    if (direction == ParsedPaymentDirection.transfer) return 'Transfers';
    if (direction == ParsedPaymentDirection.refund) return 'Refunds';

    final combined = '$merchant $text'.toLowerCase();

    if (combined.contains('salary') || combined.contains('payroll') || combined.contains('stipend')) {
      return 'Salary';
    }

    if (combined.contains('swiggy') ||
        combined.contains('zomato') ||
        combined.contains('mcdonald') ||
        combined.contains('starbucks') ||
        combined.contains('kfc') ||
        combined.contains('domino') ||
        combined.contains('restaurant') ||
        combined.contains('cafe') ||
        combined.contains('dining') ||
        combined.contains('blinkit') ||
        combined.contains('zepto') ||
        combined.contains('instamart') ||
        combined.contains('bigbasket') ||
        combined.contains('grocery') ||
        combined.contains('supermarket')) {
      return 'Food';
    }

    if (combined.contains('uber') ||
        combined.contains('ola') ||
        combined.contains('rapido') ||
        combined.contains('metro') ||
        combined.contains('fuel') ||
        combined.contains('petrol') ||
        combined.contains('diesel') ||
        combined.contains('shell') ||
        combined.contains('indian oil') ||
        combined.contains('hpcl') ||
        combined.contains('bpcl') ||
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
        combined.contains('google storage') ||
        combined.contains('github') ||
        combined.contains('aws') ||
        combined.contains('digitalocean')) {
      return 'Subscriptions';
    }

    if (combined.contains('amazon') ||
        combined.contains('flipkart') ||
        combined.contains('myntra') ||
        combined.contains('zara') ||
        combined.contains('h&m') ||
        combined.contains('shopping')) {
      return 'Shopping';
    }

    if (combined.contains('electricity') ||
        combined.contains('bescom') ||
        combined.contains('water') ||
        combined.contains('gas') ||
        combined.contains('airtel') ||
        combined.contains('jio') ||
        combined.contains('broadband') ||
        combined.contains('wifi') ||
        combined.contains('bill')) {
      return 'Bills';
    }

    if (direction == ParsedPaymentDirection.inflow) {
      return 'Income';
    }

    return 'General';
  }
}
