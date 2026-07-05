import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/crucible_state.dart';
import '../../core/theme/app_theme.dart';
import 'crucible_provider.dart';

class CruciblePage extends ConsumerStatefulWidget {
  final CrucibleState crucibleState;
  const CruciblePage({super.key, required this.crucibleState});

  @override
  ConsumerState<CruciblePage> createState() => _CruciblePageState();
}

class _CruciblePageState extends ConsumerState<CruciblePage> {
  final _proofController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _proofController.dispose();
    super.dispose();
  }

  void _submitProof() async {
    final text = _proofController.text.trim();
    if (text.length < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('INSUFFICIENT PROOF. EXPLAIN DETAILED RESOLUTION OR ACTION TAKEN.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await ref.read(crucibleProvider.notifier).resolveProof(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.crucibleState;
    final hours = state.hoursRemaining;
    final isExpired = state.isExpired;

    return Scaffold(
      backgroundColor: const Color(0xFF150000), // Terrifying deep red/black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 28),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "SYSTEM LOCKDOWN • BANKRUPTCY PROTOCOL",
                      style: TextStyle(
                        color: AppTheme.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: AppTheme.warning, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    const Text(
                      "THE CRUCIBLE TRIGGERED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.commitment.isEmpty ? "REPEATED PERFORMANCE DEFICIT DETECTED" : state.commitment.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppTheme.border, height: 1),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${state.timesTriggered}",
                              style: const TextStyle(color: AppTheme.warning, fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            const Text(
                              "REGRESSION COUNT",
                              style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              isExpired ? "0" : "$hours",
                              style: TextStyle(
                                color: isExpired ? AppTheme.warning : Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              "HOURS TO LOCK",
                              style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "MANDATORY CONFRONTATION PROOF:",
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _proofController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6),
                  decoration: InputDecoration(
                    hintText: "State clearly how you confronted or eliminated this bottleneck.\n\nExample: 'Had the difficult conversation with X and restructured project timeline.'",
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                    filled: true,
                    fillColor: Colors.black,
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.border)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.warning, width: 2)),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warning,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: _isSubmitting ? null : _submitProof,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text(
                        "SUBMIT PROOF & UNLOCK SYSTEM",
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.8, fontSize: 13),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
