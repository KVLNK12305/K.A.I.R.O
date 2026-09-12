
class IngestionResult {
  final String source;
  final int totalReceived;
  final int newPersisted;
  final int duplicatesSkipped;
  final int resolvedEventsCreated;
  final int ignoredOrFailed;
  final List<String> errorMessages;

  const IngestionResult({
    required this.source,
    required this.totalReceived,
    required this.newPersisted,
    required this.duplicatesSkipped,
    required this.resolvedEventsCreated,
    required this.ignoredOrFailed,
    this.errorMessages = const [],
  });

  bool get hasErrors => errorMessages.isNotEmpty;

  @override
  String toString() {
    return 'IngestionResult(source: $source, received: $totalReceived, persisted: $newPersisted, '
        'duplicates: $duplicatesSkipped, resolved: $resolvedEventsCreated, ignored: $ignoredOrFailed)';
  }
}

abstract class PaymentIngestionAdapter {
  String get sourceName;
  Future<IngestionResult> ingest();
}
