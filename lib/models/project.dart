class Project {
  final String name;
  final String description;
  final String language;
  final int stars;
  final int forks;
  final String url;
  final String? homepage;
  final List<String> topics;
  final bool isFeatured;
  final String? thumbnailUrl;
  
  const Project({
    required this.name,
    required this.description,
    required this.language,
    required this.stars,
    required this.forks,
    required this.url,
    this.homepage,
    this.topics = const [],
    this.isFeatured = false,
    this.thumbnailUrl,
  });
}

enum ProjectCategory { main, additional }