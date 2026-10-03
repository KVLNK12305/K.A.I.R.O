import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/kairo_design_system.dart';
import '../../../core/models/architecture_artifact.dart';
import '../../../core/services/mermaid_ingestion_service.dart';

class MermaidViewer extends StatefulWidget {
  final ArchitectureArtifact artifact;
  final ParsedMermaid parsed;
  final VoidCallback? onEdit;

  const MermaidViewer({
    super.key,
    required this.artifact,
    required this.parsed,
    this.onEdit,
  });

  @override
  State<MermaidViewer> createState() => _MermaidViewerState();
}

class _MermaidViewerState extends State<MermaidViewer> {
  bool _showRawSource = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top control bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                KairoStatus(
                  label: widget.artifact.architectureType.toUpperCase(),
                  type: KairoStatusType.recommended,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.artifact.sourcePath,
                  style: const TextStyle(
                    color: KairoTheme.textMuted,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (widget.onEdit != null)
                  IconButton(
                    tooltip: "Edit Mermaid Snippet",
                    icon: const Icon(Icons.edit_note, color: KairoTheme.textSecondary, size: 18),
                    onPressed: widget.onEdit,
                  ),
                IconButton(
                  tooltip: _showRawSource ? "Show Visual Graph" : "Show Raw Mermaid (.mmd)",
                  icon: Icon(
                    _showRawSource ? Icons.schema_outlined : Icons.code,
                    color: KairoTheme.textSecondary,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _showRawSource = !_showRawSource),
                ),
                IconButton(
                  tooltip: "Copy Mermaid Source",
                  icon: const Icon(Icons.copy, color: KairoTheme.textMuted, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.artifact.rawMermaid));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Mermaid source copied to clipboard"),
                        backgroundColor: KairoTheme.surfaceElevated,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: KairoTheme.xs),

        // Node & Edge Metrics
        Row(
          children: [
            _buildMetricChip("NODES", widget.parsed.nodes.length.toString()),
            const SizedBox(width: 8),
            _buildMetricChip("EDGES", widget.parsed.edges.length.toString()),
            const SizedBox(width: 8),
            _buildMetricChip("FLOW", widget.parsed.direction),
          ],
        ),
        const SizedBox(height: KairoTheme.md),

        // Main Visual Graph or Raw Source
        if (_showRawSource)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(KairoTheme.md),
            decoration: BoxDecoration(
              color: KairoTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
              border: Border.all(color: KairoTheme.border),
            ),
            child: SelectableText(
              widget.artifact.rawMermaid,
              style: const TextStyle(
                color: KairoTheme.textPrimary,
                fontFamily: 'monospace',
                fontSize: 11,
                height: 1.4,
              ),
            ),
          )
        else
          _buildVisualGraph(),
      ],
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: KairoTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
        border: Border.all(color: KairoTheme.border),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          color: KairoTheme.textMuted,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildVisualGraph() {
    if (widget.parsed.nodes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(KairoTheme.lg),
        decoration: BoxDecoration(
          color: KairoTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
          border: Border.all(color: KairoTheme.border),
        ),
        child: const Text(
          "Raw Mermaid artifact loaded. Tap the code icon above to inspect syntax.",
          style: TextStyle(color: KairoTheme.textMuted, fontSize: 11),
        ),
      );
    }

    final isHorizontal = widget.parsed.direction == 'LR' || widget.parsed.direction == 'RL';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KairoTheme.md),
      decoration: BoxDecoration(
        color: KairoTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
        border: Border.all(color: KairoTheme.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flow sequence
              Wrap(
                direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (int i = 0; i < widget.parsed.nodes.length; i++) ...[
                    _buildNodeBox(widget.parsed.nodes[i]),
                    if (i < widget.parsed.nodes.length - 1)
                      Icon(
                        isHorizontal ? Icons.arrow_forward_rounded : Icons.arrow_downward_rounded,
                        color: KairoTheme.textMuted,
                        size: 14,
                      ),
                  ],
                ],
              ),
              if (widget.parsed.edges.isNotEmpty) ...[
                const SizedBox(height: KairoTheme.lg),
                const Text(
                  "DECLARED PIPELINES / EDGES",
                  style: TextStyle(
                    color: KairoTheme.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: KairoTheme.xs),
                for (final edge in widget.parsed.edges)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.subdirectory_arrow_right, size: 12, color: KairoTheme.observed),
                        const SizedBox(width: 4),
                        Text(
                          "${edge.from}  →  ${edge.to}",
                          style: const TextStyle(
                            color: KairoTheme.textSecondary,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeBox(MermaidNode node) {
    IconData icon = Icons.widgets_outlined;
    if (node.shape == 'database') icon = Icons.storage_outlined;
    if (node.shape == 'diamond') icon = Icons.call_split_outlined;
    if (node.shape == 'round') icon = Icons.bubble_chart_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: KairoTheme.surface,
        borderRadius: BorderRadius.circular(
          node.shape == 'round' ? KairoTheme.radiusLg : KairoTheme.radiusSm,
        ),
        border: Border.all(
          color: node.shape == 'database' ? KairoTheme.observed.withValues(alpha: 0.6) : KairoTheme.borderActive,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: KairoTheme.observed),
          const SizedBox(width: 6),
          Text(
            node.label,
            style: const TextStyle(
              color: KairoTheme.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
