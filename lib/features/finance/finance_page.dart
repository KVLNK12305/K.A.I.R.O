import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/financial_event.dart';
import '../../core/models/account.dart';
import '../../core/services/financial_ledger_service.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  ConsumerState<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

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
                    const SizedBox(height: KairoTheme.xs),
                    DropdownButtonFormField<int>(
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
                      items: accounts.map((a) {
                        return DropdownMenuItem<int>(
                          value: a.id,
                          child: Text("${a.name} (${_currencyFormat.format(a.currentBalance)})"),
                        );
                      }).toList(),
                      onChanged: (val) => setModalState(() => selectedSourceId = val),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Category & Merchant
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: categoryCtrl,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: "CATEGORY",
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

                        ref.invalidate(financialOverviewProvider);
                        ref.invalidate(recentFinancialEventsProvider);
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
    final overviewAsync = ref.watch(financialOverviewProvider);
    final recentAsync = ref.watch(recentFinancialEventsProvider);
    final accountsFuture = ref.watch(financialLedgerServiceProvider).getAccounts();

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(financialOverviewProvider);
            ref.invalidate(recentFinancialEventsProvider);
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
                              "CAPITAL LEDGER",
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
                              "BURN & LIQUIDITY",
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
                            text: "LOG EVENT",
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

              // Overview Burn & Liquidity Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.sm),
                  child: overviewAsync.when(
                    data: (data) => _buildBurnOverviewCard(data),
                    loading: () => const KairoCard(
                      child: SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
                      ),
                    ),
                    error: (e, _) => KairoCard(
                      child: Text("Finance overview error: $e", style: const TextStyle(color: KairoTheme.warning)),
                    ),
                  ),
                ),
              ),

              // On-Device Accounts List
              SliverToBoxAdapter(
                child: FutureBuilder<List<Account>>(
                  future: accountsFuture,
                  builder: (ctx, snap) {
                    final accounts = snap.data ?? [];
                    if (accounts.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KairoSectionHeader(title: "ON-DEVICE ACCOUNTS"),
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

              // Transactions Stream Section Header
              const SliverToBoxAdapter(
                child: KairoSectionHeader(title: "RECENT TRANSACTIONS"),
              ),

              // Transactions List
              recentAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: KairoEmptyState(
                        title: "NO TRANSACTIONS RECORDED",
                        description: "Log expenses, investments, or transfers above to track capital outflow.",
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: 3),
                          child: _buildTransactionTile(event),
                        );
                      },
                      childCount: events.length,
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
                    child: Text("Error loading transactions: $err", style: const TextStyle(color: KairoTheme.warning)),
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

  Widget _buildBurnOverviewCard(FinancialOverview overview) {
    return KairoCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TODAY'S OUTFLOW",
                      style: TextStyle(
                        color: KairoTheme.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _currencyFormat.format(overview.todayBurn),
                        style: const TextStyle(
                          color: KairoTheme.warning,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: KairoTheme.border),
              const SizedBox(width: KairoTheme.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CURRENT WEEK BURN",
                      style: TextStyle(
                        color: KairoTheme.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _currencyFormat.format(overview.weekBurn),
                        style: const TextStyle(
                          color: KairoTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const KairoDivider(verticalMargin: KairoTheme.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("MONTH OUTFLOW", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(overview.monthBurn), style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("INVESTED (MTD)", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(overview.totalInvestedMonth), style: const TextStyle(color: KairoTheme.success, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("LIQUID CASH", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_currencyFormat.format(overview.totalCashBalance), style: const TextStyle(color: KairoTheme.observed, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
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

  Widget _buildTransactionTile(FinancialEvent event) {
    Color typeColor = KairoTheme.warning;
    String sign = "-";
    IconData icon = Icons.arrow_outward;

    if (event.type == FinancialEventType.inflow) {
      typeColor = KairoTheme.success;
      sign = "+";
      icon = Icons.arrow_downward;
    } else if (event.type == FinancialEventType.investment) {
      typeColor = KairoTheme.observed;
      sign = "";
      icon = Icons.trending_up;
    } else if (event.type == FinancialEventType.transfer) {
      typeColor = KairoTheme.inferred;
      sign = "";
      icon = Icons.swap_horiz;
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
                Text(
                  event.merchantOrEntity.isNotEmpty ? event.merchantOrEntity : event.category,
                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
                ),
                Text(
                  "${event.category.toUpperCase()} • $dateStr",
                  style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
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
