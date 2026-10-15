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
}
