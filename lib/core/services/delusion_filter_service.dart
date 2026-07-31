class DelusionAnalysis {
  final bool hasDelusion;
  final String phraseDetected;
  final String suggestedRewrite;
  final double severityScore; // 0.0 to 1.0

  DelusionAnalysis({
    required this.hasDelusion,
    required this.phraseDetected,
    required this.suggestedRewrite,
    required this.severityScore,
  });
}

class DelusionFilterService {
  static final Map<RegExp, String> _delusionPatterns = {
    RegExp(r'\btried to\b', caseSensitive: false):
        'attempted without committing to execution',
    RegExp(r'\bgot (too )?busy\b', caseSensitive: false):
        'prioritized low-leverage distractions over Peak tasks',
    RegExp(r'\bran out of time\b', caseSensitive: false):
        'mismanaged time allocation and allowed scope creep',
    RegExp(r'\bwas impossible\b', caseSensitive: false):
        'allowed friction to halt progress',
    RegExp(r'\bhopefully\b', caseSensitive: false):
        'relied on passive wishful thinking',
    RegExp(r'\bunexpectedly\b', caseSensitive: false):
        'failed to build buffer time for foreseeable interruptions',
    RegExp(r'\bcouldn\x27t finish\b', caseSensitive: false):
        'stopped before the target was completed',
    RegExp(r'\bnext week will be better\b', caseSensitive: false):
        'deferred responsibility to future self',
    RegExp(r'\bjust wasn\x27t feeling it\b', caseSensitive: false):
        'prioritized emotional state over discipline',
  };

  /// Analyzes text input in real-time to detect passive rationalizations and return ownership rewrites.
  static DelusionAnalysis analyze(String input) {
    if (input.trim().isEmpty) {
      return DelusionAnalysis(
        hasDelusion: false,
        phraseDetected: '',
        suggestedRewrite: '',
        severityScore: 0.0,
      );
    }

    for (final entry in _delusionPatterns.entries) {
      final match = entry.key.firstMatch(input);
      if (match != null) {
        final phrase = match.group(0) ?? '';
        final suggestion = entry.value;

        // Generate active rewrite replacing the passive phrase
        final rewrite = input.replaceFirst(entry.key, suggestion);

        return DelusionAnalysis(
          hasDelusion: true,
          phraseDetected: phrase,
          suggestedRewrite: rewrite,
          severityScore: 0.85,
        );
      }
    }

    return DelusionAnalysis(
      hasDelusion: false,
      phraseDetected: '',
      suggestedRewrite: '',
      severityScore: 0.0,
    );
  }
}
