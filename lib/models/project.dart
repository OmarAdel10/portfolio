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
  });
}