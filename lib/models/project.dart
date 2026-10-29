import '../components/cupertino_icon.dart';

class Project {
  final String name;
  final String description;
  final String language;
  final String category;
  final int stars;
  final int forks;
  final String url;
  final String? homepage;
  final List<String> topics;
  final bool isFeatured;
  final String? thumbnailUrl;

  /// Absolute path (e.g. `/images/logos/budgetwise.png`) to the product logo
  /// shown in the card instead of the language fallback. `null` falls back.
  final String? logoUrl;

  /// Optional project-specific icon used when no product logo is available.
  final CupertinoIconName? icon;

  /// Palette slot for [icon].
  final CupertinoIconColor iconColor;

  /// Light-theme variant of the logo. If null, falls back to `logoUrl`.
  final String? logoUrlLight;

  /// Dark-theme variant of the logo. If null, falls back to `logoUrl`.
  final String? logoUrlDark;

  const Project({
    required this.name,
    required this.description,
    required this.language,
    this.category = 'Other',
    required this.stars,
    required this.forks,
    required this.url,
    this.homepage,
    this.topics = const [],
    this.isFeatured = false,
    this.thumbnailUrl,
    this.logoUrl,
    this.icon,
    this.iconColor = CupertinoIconColor.current,
    this.logoUrlLight,
    this.logoUrlDark,
  });

  /// The tech stack as one reader-facing line.
  ///
  /// The raw [topics] are GitHub slugs (`cloudflare-workers`, `stt`,
  /// `dotnet`) and the raw [language] repeats whatever the topics already
  /// say. This joins the two into a single list of spelled-out names with
  /// the duplicates dropped — the same string for every card.
  String get stackLabel {
    final parts = <String>[];
    final seen = <String>{};

    void add(String raw) {
      final label = _humanise(raw);
      if (label.isEmpty) return;
      if (!seen.add(label.toLowerCase())) return;
      parts.add(label);
    }

    for (final term in language.split('·')) {
      add(term.trim());
    }
    for (final topic in topics) {
      add(topic);
    }
    return parts.join(', ');
  }
}

/// Spellings that a generic title-caser would get wrong: acronyms, proper
/// nouns and framework names.
const Map<String, String> _topicLabels = {
  'ai': 'AI',
  'api': 'API',
  'audio-visualization': 'Audio visualization',
  'bloc': 'BLoC',
  'cli': 'CLI',
  'cloudflare-workers': 'Cloudflare Workers',
  'dotnet': '.NET',
  'explainable-ai': 'Explainable AI',
  'ios': 'iOS',
  'llm': 'LLM',
  'machine-learning': 'Machine learning',
  'mnist': 'MNIST',
  'offline-reading': 'Offline reading',
  'offline-stt': 'Offline STT',
  'pos': 'POS',
  'prayer-times': 'Prayer times',
  'sdk': 'SDK',
  'shap': 'SHAP',
  'sql': 'SQL',
  'sqlite': 'SQLite',
  'stt': 'STT',
  'swiftui': 'SwiftUI',
  'tts': 'TTS',
  'ui': 'UI',
  'voice-assistant': 'Voice assistant',
  'websockets': 'WebSockets',
};

/// Turns a slug or a raw language term into something worth printing.
String _humanise(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return '';

  final mapped = _topicLabels[value.toLowerCase()];
  if (mapped != null) return mapped;

  // Already a readable label: it carries punctuation (`C#`, `.NET`) or
  // internal capitals (`TypeScript`). Leave it alone.
  if (value.contains(RegExp(r'[^a-zA-Z0-9]')) || RegExp(r'[a-z][A-Z]').hasMatch(value)) {
    return value;
  }

  // Sentence case: first word capitalised, the rest plain.
  final words = value.split('-').where((word) => word.isNotEmpty).map((word) => word.toLowerCase()).toList();
  if (words.isEmpty) return '';
  return words
      .map((word) {
        return word == words.first ? word[0].toUpperCase() + word.substring(1) : word;
      })
      .join(' ');
}
