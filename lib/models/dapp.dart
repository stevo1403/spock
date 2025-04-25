class DApp {
  final String id;
  final String name;
  final String description;
  final String category;
  final String icon;
  final String url;
  final bool featured;

  DApp({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.url,
    this.featured = false,
  });

  factory DApp.fromJson(Map<String, dynamic> json) {
    return DApp(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      icon: json['icon'],
      url: json['url'],
      featured: json['featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'icon': icon,
      'url': url,
      'featured': featured,
    };
  }
}