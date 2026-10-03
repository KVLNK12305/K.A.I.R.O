import 'package:flutter/material.dart';
import '../../../core/theme/kairo_design_system.dart';
import '../../../core/models/architecture_drift.dart';

class ArchitectureDriftCard extends StatelessWidget {
  final ArchitectureDrift drift;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onPromoteToTask;

  const ArchitectureDriftCard({
    super.key,
    required this.drift,
    this.onAcknowledge,
    this.onPromoteToTask,
  });

  @override
  Widget build(BuildContext context) {
    return KairoCard(
      borderColor: KairoTheme.recommended.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: KairoTheme.recommended, size: 14),
                  SizedBox(width: 6),
                  Text(
                    "ARCHITECTURE DRIFT",
                    style: TextStyle(
                      color: KairoTheme.recommended,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              KairoStatus(
                label: drift.classification,
                type: KairoStatusType.recommended,
              ),
            ],
          ),
          const SizedBox(height: KairoTheme.md),

          // Expected vs Observed comparison
          _buildDriftRow("Expected:", drift.expected, KairoTheme.textPrimary),
          const SizedBox(height: 6),
          _buildDriftRow("Observed:", drift.observed, KairoTheme.textSecondary),
          const SizedBox(height: 6),
          _buildDriftRow("Missing:", drift.missing, KairoTheme.warning),

          if (drift.notes.isNotEmpty) ...[
            const SizedBox(height: KairoTheme.sm),
            Text(
              drift.notes,
              style: const TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 10,
                height: 1.3,
              ),
            ),
          ],

          const SizedBox(height: KairoTheme.md),

          // Agency Rule Note & User Actions
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: KairoTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, size: 12, color: KairoTheme.textMuted),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "K.A.I.R.O. Agency Rule: Observation only. No task automatically created.",
                    style: TextStyle(
                      color: KairoTheme.textMuted,
                      fontSize: 9,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: KairoTheme.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onAcknowledge != null && !drift.isAcknowledged)
                KairoButton(
                  text: "ACKNOWLEDGE",
                  onPressed: onAcknowledge,
                ),
              if (onPromoteToTask != null) ...[
                const SizedBox(width: KairoTheme.sm),
                KairoButton(
                  text: "CREATE TASK...",
                  isPrimary: true,
                  icon: Icons.add,
                  onPressed: onPromoteToTask,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriftRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: const TextStyle(
              color: KairoTheme.textMuted,
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
