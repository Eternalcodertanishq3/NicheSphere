/// NicheSphere — Community Model (Section 4)
class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final String bannerUrl;
  final int memberCount;
  final String creatorId;
  final List<String> adminIds;
  final bool isPrivate;
  final DateTime createdAt;
  final List<String> tags;
  final double activityScore;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.bannerUrl = '',
    this.memberCount = 0,
    required this.creatorId,
    this.adminIds = const [],
    this.isPrivate = false,
    required this.createdAt,
    this.tags = const [],
    this.activityScore = 0,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      bannerUrl: json['bannerUrl'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
      creatorId: json['creatorId'] as String? ?? '',
      adminIds: List<String>.from(json['adminIds'] ?? []),
      isPrivate: json['isPrivate'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      activityScore: (json['activityScore'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
        'bannerUrl': bannerUrl,
        'memberCount': memberCount,
        'creatorId': creatorId,
        'adminIds': adminIds,
        'isPrivate': isPrivate,
        'createdAt': createdAt.toIso8601String(),
        'tags': tags,
        'activityScore': activityScore,
      };
}
