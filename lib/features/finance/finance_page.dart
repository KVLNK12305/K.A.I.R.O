import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/financial_event.dart';
import '../../core/models/account.dart';
import '../../core/services/financial_ledger_service.dart';
import '../../core/services/finance/android_notification_adapter.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  ConsumerState<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage> with WidgetsBindingObserver {
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
  bool _isObserverGranted = false;
  bool _isCheckingObserver = true;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AndroidNotificationAdapter.onPaymentNotificationCaptured = () {
      if (mounted) _refreshAllProviders();
    };
    _checkObserverStatus();
    _syncPendingNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AndroidNotificationAdapter.onPaymentNotificationCaptured = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkObserverStatus();
      _syncPendingNotifications();
    }
  }

  Future<void> _syncPendingNotifications() async {
    try {
      await ref.read(financialLedgerServiceProvider).syncAndroidNotifications();
      _refreshAllProviders();
    } catch (_) {}
  }

  Future<void> _checkObserverStatus() async {
    if (!Platform.isAndroid) {
      if (mounted) setState(() => _isCheckingObserver = false);
      return;
    }
    final granted = await AndroidNotificationAdapter.isPermissionGranted();
    if (mounted) {
      setState(() {
        _isObserverGranted = granted;
        _isCheckingObserver = false;
      });
    }
  }

  Future<void> _showObserverDiagnosticsModal(BuildContext context) async {
    final diags = await AndroidNotificationAdapter.getDiagnostics();
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final timeStr = diags.lastConnectedTime != null
                ? DateFormat('MMM d, HH:mm:ss').format(diags.lastConnectedTime!)
                : "NEVER";

            return Padding(
              padding: const EdgeInsets.all(KairoTheme.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "NOTIFICATION OBSERVER TELEMETRY",
                        style: TextStyle(
                          color: KairoTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          letterSpacing: 1.1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                        onPressed: () => Navigator.pop(ctx),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: KairoTheme.md),

                  // Diagnostic Metric Badges
                  Container(
                    padding: const EdgeInsets.all(KairoTheme.md),
                    decoration: BoxDecoration(
                      color: KairoTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      border: Border.all(color: KairoTheme.border),
                    ),
                    child: Column(
                      children: [
                        _buildDiagRow("STATUS", diags.stateName, diags.isConnected ? KairoTheme.success : KairoTheme.warning),
                        const SizedBox(height: 6),
                        _buildDiagRow("CONNECTED", diags.isConnected ? "YES" : "NO", diags.isConnected ? KairoTheme.success : KairoTheme.warning),
                        const SizedBox(height: 6),
                        _buildDiagRow("LAST CONNECTED", timeStr, KairoTheme.textSecondary),
                        const SizedBox(height: 6),
                        _buildDiagRow("NOTIFICATIONS OBSERVED", "${diags.totalObserved}", KairoTheme.textPrimary),
                        const SizedBox(height: 6),
                        _buildDiagRow("PAYMENTS DETECTED", "${diags.totalFinancial}", KairoTheme.observed),
                      ],
                    ),
                  ),
                  const SizedBox(height: KairoTheme.md),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: KairoButton(
                          text: "REBIND LISTENER",
                          icon: Icons.refresh,
                          isPrimary: false,
                          onPressed: () async {
                            final success = await AndroidNotificationAdapter.rebindService();
                            await _checkObserverStatus();
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success ? "Requested Android to rebind notification listener." : "Rebind request sent.",
                                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      Expanded(
                        child: KairoButton(
                          text: "OPEN SETTINGS",
                          icon: Icons.settings,
                          isPrimary: true,
                          onPressed: () async {
                            await AndroidNotificationAdapter.requestPermission();
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KairoTheme.md),

                  const Text(
                    "RECENT EVENT AUDIT LOG",
                    style: TextStyle(
                      color: KairoTheme.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Recent Event Logs
                  SizedBox(
                    height: 180,
                    child: diags.recentLogs.isEmpty
                        ? const Center(
                            child: Text(
                              "No notifications observed yet by the listener service.",
                              style: TextStyle(color: KairoTheme.textFaint, fontSize: 11),
                            ),
                          )
                        : ListView.builder(
                            itemCount: diags.recentLogs.length,
                            reverse: true,
                            itemBuilder: (c, idx) {
                              final log = diags.recentLogs[idx];
                              final time = log['timestamp'] is int
                                  ? DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(log['timestamp'] as int))
                                  : "";
                              final pkg = (log['packageName'] ?? '').toString();
                              final eventType = (log['eventType'] ?? '').toString();
                              final kw = (log['matchedKeyword'] ?? '').toString();
                              final isFin = log['isFinancial'] == true;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  "[$time] $pkg • $eventType ${isFin ? '[$kw]' : ''}",
                                  style: TextStyle(
                                    color: isFin ? KairoTheme.success : KairoTheme.textMuted,
                                    fontSize: 9,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDiagRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w900)),
      ],
    );
  }

  Future<void> _handleCsvImport() async {
    setState(() => _isImporting = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final ledger = ref.read(financialLedgerServiceProvider);
        final ingestion = await ledger.ingestCsv(content);

        _refreshAllProviders();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: KairoTheme.surfaceElevated,
              content: Text(
                "CSV IMPORT: ${ingestion.resolvedEventsCreated} events recorded, ${ingestion.duplicatesSkipped} duplicates skipped, ${ingestion.ignoredOrFailed} ignored.",
                style: const TextStyle(color: KairoTheme.textPrimary, fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: KairoTheme.surfaceElevated,
            content: Text(
              "CSV Import failed: $e",
              style: const TextStyle(color: KairoTheme.warning, fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  void _refreshAllProviders() {
    final selectedMonth = ref.read(selectedMonthProvider);
    ref.invalidate(monthlySummaryProvider(selectedMonth));
    ref.invalidate(availableMonthsProvider);
    ref.invalidate(financialOverviewProvider);
    ref.invalidate(recentFinancialEventsProvider);
  }

  void _showLogTransactionModal(BuildContext context, List<Account> accounts) {
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'General');
    final merchantCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    FinancialEventType selectedType = FinancialEventType.outflow;
    int? selectedSourceId = accounts.isNotEmpty ? accounts.first.id : null;
    int? selectedDestId;

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: KairoTheme.xl,
                right: KairoTheme.xl,
                top: KairoTheme.xl,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + KairoTheme.xl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "RECORD CAPITAL EVENT",
                          style: TextStyle(
                            color: KairoTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                          onPressed: () => Navigator.pop(ctx),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Event Type Selector Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: FinancialEventType.values.map((type) {
                          final isSelected = selectedType == type;
                          String label = type.name.toUpperCase();
                          Color activeColor = KairoTheme.recommended;
                          if (type == FinancialEventType.inflow) activeColor = KairoTheme.success;
                          if (type == FinancialEventType.investment) activeColor = KairoTheme.observed;
                          if (type == FinancialEventType.transfer) activeColor = KairoTheme.inferred;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: isSelected ? Colors.black : KairoTheme.textSecondary,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: activeColor,
                              backgroundColor: KairoTheme.surfaceElevated,
                              side: BorderSide(color: isSelected ? activeColor : KairoTheme.border),
                              onSelected: (_) {
                                setModalState(() => selectedType = type);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.lg),

                    // Amount Field
                    TextField(
                      controller: amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        color: KairoTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                      decoration: InputDecoration(
                        prefixText: "₹ ",
                        prefixStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 22, fontFamily: 'monospace'),
                        hintText: "0.00",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.borderActive),
                        ),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Source Account Picker
                    const Text(
                      "SOURCE ACCOUNT",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int?>(
                      initialValue: selectedSourceId,
                      dropdownColor: KairoTheme.surfaceElevated,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text("Unlinked / External", style: TextStyle(color: KairoTheme.textMuted)),
                        ),
                        ...accounts.map((a) => DropdownMenuItem<int?>(
                          value: a.id,
                          child: Text("${a.name} (${_currencyFormat.format(a.currentBalance)})"),
                        )),
                      ],
                      onChanged: (val) => setModalState(() => selectedSourceId = val),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Destination Account (for transfer / investment)
                    if (selectedType == FinancialEventType.transfer || selectedType == FinancialEventType.investment) ...[
                      const Text(
                        "DESTINATION ACCOUNT",
                        style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int?>(
                        initialValue: selectedDestId,
                        dropdownColor: KairoTheme.surfaceElevated,
                        style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: KairoTheme.surfaceElevated,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                            borderSide: const BorderSide(color: KairoTheme.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                            borderSide: const BorderSide(color: KairoTheme.border),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text("External Destination", style: TextStyle(color: KairoTheme.textMuted)),
                          ),
                          ...accounts.map((a) => DropdownMenuItem<int?>(
                            value: a.id,
                            child: Text(a.name),
                          )),
                        ],
                        onChanged: (val) => setModalState(() => selectedDestId = val),
                      ),
                      const SizedBox(height: KairoTheme.md),
                    ],

                    // Category & Merchant Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: categoryCtrl,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: "CATEGORY",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              hintText: "General",
                              hintStyle: const TextStyle(color: KairoTheme.textFaint, fontSize: 12),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                borderSide: const BorderSide(color: KairoTheme.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                borderSide: const BorderSide(color: KairoTheme.border),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: KairoTheme.sm),
                        Expanded(
                          child: TextField(
                            controller: merchantCtrl,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: "ENTITY / MERCHANT",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              hintText: "e.g. Swiggy, AWS",
                              hintStyle: const TextStyle(color: KairoTheme.textFaint, fontSize: 12),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                borderSide: const BorderSide(color: KairoTheme.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                borderSide: const BorderSide(color: KairoTheme.border),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Notes
                    TextField(
                      controller: notesCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "NOTES (OPTIONAL)",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.xl),

                    KairoButton(
                      text: "COMMIT TO LEDGER",
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () async {
                        final amount = double.tryParse(amountCtrl.text.trim());
                        if (amount == null || amount <= 0) return;

                        await ref.read(financialLedgerServiceProvider).logTransaction(
                          amount: amount,
                          type: selectedType,
                          category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                          merchantOrEntity: merchantCtrl.text.trim(),
                          sourceAccountId: selectedSourceId,
                          destinationAccountId: selectedDestId,
                          notes: notesCtrl.text.trim(),
                        );

                        _refreshAllProviders();
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final summaryAsync = ref.watch(monthlySummaryProvider(selectedMonth));
    final availableMonthsAsync = ref.watch(availableMonthsProvider);
    final accountsFuture = ref.watch(financialLedgerServiceProvider).getAccounts();

    final monthDisplayStr = DateFormat('MMMM yyyy').format(selectedMonth).toUpperCase();

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            await ref.read(financialLedgerServiceProvider).syncAndroidNotifications();
            await _checkObserverStatus();
            _refreshAllProviders();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // System Header Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.lg, KairoTheme.xl, KairoTheme.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CANONICAL LEDGER",
                              style: TextStyle(
                                color: KairoTheme.textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              "FINANCIAL HISTORY",
                              style: TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      FutureBuilder<List<Account>>(
                        future: accountsFuture,
                        builder: (ctx, snap) {
                          return KairoButton(
                            text: "LOG",
                            icon: Icons.add,
                            isPrimary: true,
                            onPressed: () => _showLogTransactionModal(context, snap.data ?? []),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Ingestion Control Strip (Observer status & CSV import)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: Row(
                    children: [
                      // Observer Status Badge
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (Platform.isAndroid && !_isObserverGranted) {
                              await AndroidNotificationAdapter.requestPermission();
                              await _checkObserverStatus();
                            } else {
                              await _showObserverDiagnosticsModal(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: KairoTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                              border: Border.all(
                                color: _isObserverGranted ? KairoTheme.success.withValues(alpha: 0.3) : KairoTheme.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isCheckingObserver
                                        ? KairoTheme.textMuted
                                        : (_isObserverGranted ? KairoTheme.success : KairoTheme.warning),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _isCheckingObserver
                                        ? "CHECKING OBSERVER..."
                                        : (_isObserverGranted
                                            ? "OBSERVER ACTIVE"
                                            : "OBSERVER OFF (ENABLE)"),
                                    style: TextStyle(
                                      color: _isObserverGranted ? KairoTheme.success : KairoTheme.textMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),

                      // CSV Import Button
                      KairoButton(
                        text: _isImporting ? "IMPORTING..." : "IMPORT CSV",
                        icon: Icons.upload_file,
                        isPrimary: false,
                        onPressed: _isImporting ? null : _handleCsvImport,
                      ),
                    ],
                  ),
                ),
              ),

              // Month Selector Strip
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.sm),
                  child: availableMonthsAsync.when(
                    data: (months) => _buildMonthSelector(selectedMonth, months),
                    loading: () => const SizedBox(height: 38),
                    error: (_, _) => const SizedBox(height: 38),
                  ),
                ),
              ),

              // Monthly Hero Summary Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: summaryAsync.when(
                    data: (summary) => _buildMonthlySummaryCard(summary, monthDisplayStr),
                    loading: () => const KairoCard(
                      child: SizedBox(
                        height: 140,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
                      ),
                    ),
                    error: (e, _) => KairoCard(
                      child: Text("Ledger error: $e", style: const TextStyle(color: KairoTheme.warning)),
                    ),
                  ),
                ),
              ),

              // Spending Categories Breakdown (if data exists)
              SliverToBoxAdapter(
                child: summaryAsync.when(
                  data: (summary) {
                    if (!summary.hasData || summary.categoryBreakdown.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return _buildCategoryBreakdownSection(summary);
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),

              // On-Device Accounts Horizontal Strip
              SliverToBoxAdapter(
                child: FutureBuilder<List<Account>>(
                  future: accountsFuture,
                  builder: (ctx, snap) {
                    final accounts = snap.data ?? [];
                    if (accounts.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KairoSectionHeader(title: "ON-DEVICE LIQUIDITY"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: accounts.map((acc) {
                                return Container(
                                  width: 145,
                                  margin: const EdgeInsets.only(right: KairoTheme.sm),
                                  child: KairoCard(
                                    padding: const EdgeInsets.all(KairoTheme.md),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          acc.name.toUpperCase(),
                                          style: const TextStyle(
                                            color: KairoTheme.textMuted,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'monospace',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: KairoTheme.xs),
                                        Text(
                                          _currencyFormat.format(acc.currentBalance),
                                          style: const TextStyle(
                                            color: KairoTheme.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Transactions Stream Header
              SliverToBoxAdapter(
                child: KairoSectionHeader(title: "$monthDisplayStr TRANSACTIONS"),
              ),

              // Transactions List for Selected Month
              summaryAsync.when(
                data: (summary) {
                  if (!summary.hasData || summary.events.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: KairoEmptyState(
                        title: "NO TRANSACTIONS OBSERVED",
                        description: "Import bank statement CSV or connect notification listener to record transactions.",
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = summary.events[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: 3),
                          child: _buildTransactionTile(event),
                        );
                      },
                      childCount: summary.events.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(KairoTheme.xl),
                      child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted),
                    ),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(KairoTheme.xl),
                    child: Text("Error: $err", style: const TextStyle(color: KairoTheme.warning)),
                  ),
                ),
              ),

              // Bottom padding for dock
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(DateTime current, List<DateTime> months) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: months.map((m) {
          final isSelected = m.year == current.year && m.month == current.month;
          final label = DateFormat('MMM yyyy').format(m).toUpperCase();

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: isSelected ? Colors.black : KairoTheme.textMuted,
                ),
              ),
              selected: isSelected,
              selectedColor: KairoTheme.textPrimary,
              backgroundColor: KairoTheme.surfaceElevated,
              side: BorderSide(color: isSelected ? KairoTheme.textPrimary : KairoTheme.border),
              onSelected: (_) {
                ref.read(selectedMonthProvider.notifier).state = m;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthlySummaryCard(MonthlyFinancialSummary summary, String monthStr) {
    if (!summary.hasData) {
      return KairoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthStr,
                  style: const TextStyle(
                    color: KairoTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: KairoTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: KairoTheme.border),
                  ),
                  child: const Text(
                    "NO DATA OBSERVED",
                    style: TextStyle(
                      color: KairoTheme.textMuted,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "NO TRANSACTIONS RECORDED",
              style: TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "No transactions observed for this month. K.A.I.R.O. does not fabricate zero totals when records are absent.",
              style: TextStyle(color: KairoTheme.textFaint, fontSize: 11),
            ),
          ],
        ),
      );
    }

    return KairoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthStr,
                style: const TextStyle(
                  color: KairoTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                "${summary.transactionCount} EVENTS",
                style: const TextStyle(
                  color: KairoTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Primary Metric: Actual Outflow (Consumption Spending Only)
          const Text(
            "ACTUAL CONSUMPTION SPENDING",
            style: TextStyle(
              color: KairoTheme.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _currencyFormat.format(summary.totalOutflow),
              style: const TextStyle(
                color: KairoTheme.warning,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const KairoDivider(verticalMargin: KairoTheme.md),

          // Secondary Financial Pillars (Inflow, Capital Allocation, Transfers)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TOTAL INFLOW", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(summary.totalInflow), style: const TextStyle(color: KairoTheme.success, fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("CAPITAL (INVESTED)", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(summary.totalCapitalAllocation), style: const TextStyle(color: KairoTheme.observed, fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TRANSFERS", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(summary.totalTransfers), style: const TextStyle(color: KairoTheme.inferred, fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownSection(MonthlyFinancialSummary summary) {
    final sortedCategories = summary.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalOutflow = summary.totalOutflow > 0 ? summary.totalOutflow : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KairoSectionHeader(title: "SPENDING BY CATEGORY"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl),
          child: KairoCard(
            padding: const EdgeInsets.all(KairoTheme.md),
            child: Column(
              children: sortedCategories.take(5).map((entry) {
                final percent = ((entry.value / totalOutflow) * 100).clamp(0, 100).toInt();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style: const TextStyle(
                              color: KairoTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            "${_currencyFormat.format(entry.value)} ($percent%)",
                            style: const TextStyle(
                              color: KairoTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: entry.value / totalOutflow,
                          minHeight: 4,
                          backgroundColor: KairoTheme.surfaceElevated,
                          color: KairoTheme.recommended,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(FinancialEvent event) {
    Color typeColor = KairoTheme.warning;
    String sign = "-";
    IconData icon = Icons.arrow_outward;
    String typeLabel = "OUTFLOW";

    if (event.type == FinancialEventType.inflow) {
      typeColor = KairoTheme.success;
      sign = "+";
      icon = Icons.arrow_downward;
      typeLabel = "INFLOW";
    } else if (event.type == FinancialEventType.investment) {
      typeColor = KairoTheme.observed;
      sign = "";
      icon = Icons.trending_up;
      typeLabel = "CAPITAL";
    } else if (event.type == FinancialEventType.transfer) {
      typeColor = KairoTheme.inferred;
      sign = "";
      icon = Icons.swap_horiz;
      typeLabel = "TRANSFER";
    }

    final dateStr = DateFormat('MMM d, h:mm a').format(event.timestamp);

    return KairoCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
            ),
            child: Icon(icon, color: typeColor, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.merchantOrEntity.isNotEmpty ? event.merchantOrEntity : event.category,
                        style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.source != 'manual')
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: KairoTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          event.source.toUpperCase(),
                          style: const TextStyle(color: KairoTheme.textMuted, fontSize: 7, fontFamily: 'monospace'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "$typeLabel • ${event.category.toUpperCase()} • $dateStr",
                  style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$sign${_currencyFormat.format(event.amount)}",
            style: TextStyle(
              color: typeColor,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
