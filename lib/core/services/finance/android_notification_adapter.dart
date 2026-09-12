import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../models/raw_financial_transaction.dart';
import 'payment_ingestion_adapter.dart';
import 'payment_notification_parser.dart';
import 'payment_resolution_engine.dart';

class NotificationObserverDiagnostics {
  final bool isRegistered;
  final bool isPermissionGranted;
  final bool isConnected;
  final DateTime? lastConnectedTime;
  final int totalObserved;
  final int totalFinancial;
  final int queueSize;
  final List<Map<String, dynamic>> recentLogs;

  const NotificationObserverDiagnostics({
    required this.isRegistered,
    required this.isPermissionGranted,
    required this.isConnected,
    this.lastConnectedTime,
    required this.totalObserved,
    required this.totalFinancial,
    required this.queueSize,
    required this.recentLogs,
  });

  String get stateName {
    if (!isRegistered) return "LISTENER_NOT_REGISTERED";
    if (!isPermissionGranted) return "PERMISSION_NOT_GRANTED";
    if (!isConnected) return "LISTENER_NOT_CONNECTED";
    if (totalObserved == 0) return "LISTENER_CONNECTED_NO_NOTIFICATION";
    if (totalFinancial > 0) return "PAYMENT_NOTIFICATION_DETECTED";
    return "NOTIFICATION_RECEIVED";
  }
}

class AndroidNotificationAdapter implements PaymentIngestionAdapter {
  static const MethodChannel _channel = MethodChannel('com.kairo.app/finance');
  final PaymentResolutionEngine resolutionEngine;
  final PaymentNotificationParser parser;
  static void Function()? onPaymentNotificationCaptured;

  @override
  final String sourceName = 'android_notification';

  AndroidNotificationAdapter({
    required this.resolutionEngine,
    PaymentNotificationParser? parser,
  }) : parser = parser ?? PaymentNotificationParser() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onNotificationReceived') {
      await ingest();
      onPaymentNotificationCaptured?.call();
    }
  }

  /// Check if K.A.I.R.O. has Notification Listener permission in Android Settings
  static Future<bool> isPermissionGranted() async {
    if (!Platform.isAndroid) return false;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('checkNotificationListenerPermission');
      return granted ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Launch Android Notification Access settings screen
  static Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      final bool? opened = await _channel.invokeMethod<bool>('requestNotificationListenerPermission');
      return opened ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request Android OS to rebind the NotificationListenerService
  static Future<bool> rebindService() async {
    if (!Platform.isAndroid) return false;
    try {
      final bool? result = await _channel.invokeMethod<bool>('rebindListener');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Get live diagnostic state of the Android notification observer
  static Future<NotificationObserverDiagnostics> getDiagnostics() async {
    if (!Platform.isAndroid) {
      return const NotificationObserverDiagnostics(
        isRegistered: false,
        isPermissionGranted: false,
        isConnected: false,
        totalObserved: 0,
        totalFinancial: 0,
        queueSize: 0,
        recentLogs: [],
      );
    }

    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('getDiagnosticStatus');
      if (res == null) throw Exception("Null response from getDiagnosticStatus");

      final map = Map<String, dynamic>.from(res);
      final lastTimeMs = map['lastConnectedTime'] as int? ?? 0;
      final rawLogs = (map['recentLogs'] as List<dynamic>?) ?? [];
      final logs = rawLogs.map((item) => Map<String, dynamic>.from(item as Map)).toList();

      return NotificationObserverDiagnostics(
        isRegistered: map['isRegistered'] as bool? ?? true,
        isPermissionGranted: map['isPermissionGranted'] as bool? ?? false,
        isConnected: map['isConnected'] as bool? ?? false,
        lastConnectedTime: lastTimeMs > 0 ? DateTime.fromMillisecondsSinceEpoch(lastTimeMs) : null,
        totalObserved: map['totalObserved'] as int? ?? 0,
        totalFinancial: map['totalFinancial'] as int? ?? 0,
        queueSize: map['queueSize'] as int? ?? 0,
        recentLogs: logs,
      );
    } catch (_) {
      return const NotificationObserverDiagnostics(
        isRegistered: true,
        isPermissionGranted: false,
        isConnected: false,
        totalObserved: 0,
        totalFinancial: 0,
        queueSize: 0,
        recentLogs: [],
      );
    }
  }

  @override
  Future<IngestionResult> ingest() async {
    if (!Platform.isAndroid) {
      return const IngestionResult(
        source: 'android_notification',
        totalReceived: 0,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: 0,
        errorMessages: ['Notification ingestion is only available on Android'],
      );
    }

    List<dynamic> rawList = [];
    try {
      final res = await _channel.invokeMethod<List<dynamic>>('getPendingNotifications');
      if (res != null) rawList = res;
    } catch (e) {
      return IngestionResult(
        source: sourceName,
        totalReceived: 0,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: 0,
        errorMessages: ['Error fetching pending notifications: $e'],
      );
    }

    if (rawList.isEmpty) {
      return const IngestionResult(
        source: 'android_notification',
        totalReceived: 0,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: 0,
      );
    }

    final rawTxns = <RawFinancialTransaction>[];
    int ignored = 0;

    for (final item in rawList) {
      if (item is! Map) {
        ignored++;
        continue;
      }

      final packageName = (item['packageName'] ?? '').toString();
      final title = (item['title'] ?? '').toString();
      final body = (item['body'] ?? '').toString();
      final postTimeRaw = item['postTime'];
      final postTime = postTimeRaw is int
          ? DateTime.fromMillisecondsSinceEpoch(postTimeRaw)
          : DateTime.now();

      final parsed = parser.parse(
        packageName: packageName,
        title: title,
        body: body,
        timestamp: postTime,
      );

      if (parsed == null || parsed.status == ParsedPaymentStatus.failed) {
        ignored++;
        continue;
      }

      final raw = RawFinancialTransaction()
        ..source = sourceName
        ..timestamp = parsed.timestamp ?? postTime
        ..amount = parsed.amount
        ..currency = parsed.currency
        ..rawTitle = title
        ..rawBody = body
        ..rawMerchant = parsed.rawMerchant
        ..paymentMethod = parsed.paymentMethod
        ..sourceAccountHint = parsed.sourceAccountHint
        ..referenceNumber = parsed.referenceNumber
        ..ingestedAt = DateTime.now()
        ..rawPayload = jsonEncode(Map<String, dynamic>.from(item));

      rawTxns.add(raw);
    }

    return await resolutionEngine.resolveBatch(
      rawTxns,
      sourceName: sourceName,
      initialIgnoredCount: ignored,
    );
  }
}
