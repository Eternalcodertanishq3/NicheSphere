/// NicheSphere — Badge Model (Section 8.1)
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String category;
  final int tier;
  final int requiredCount;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl = '',
    required this.category,
    this.tier = 1,
    this.requiredCount = 1,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      tier: json['tier'] as int? ?? 1,
      requiredCount: json['requiredCount'] as int? ?? 1,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}
