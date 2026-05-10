/// NicheSphere — User Model (Section 4)
class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? website;
  final List<String> interests;
  final int eventsHosted;
  final int eventsAttended;
  final int followersCount;
  final int followingCount;
  final List<String> badgeIds;
  final DateTime createdAt;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.location,
    this.website,
    this.interests = const [],
    this.eventsHosted = 0,
    this.eventsAttended = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.badgeIds = const [],
    required this.createdAt,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      interests: List<String>.from(json['interests'] ?? []),
      eventsHosted: json['eventsHosted'] as int? ?? 0,
      eventsAttended: json['eventsAttended'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      badgeIds: List<String>.from(json['badgeIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'location': location,
        'website': website,
        'interests': interests,
        'eventsHosted': eventsHosted,
        'eventsAttended': eventsAttended,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'badgeIds': badgeIds,
        'createdAt': createdAt.toIso8601String(),
        'isVerified': isVerified,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    String? location,
    String? website,
    List<String>? interests,
    int? eventsHosted,
    int? eventsAttended,
    int? followersCount,
    int? followingCount,
    List<String>? badgeIds,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      interests: interests ?? this.interests,
      eventsHosted: eventsHosted ?? this.eventsHosted,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      badgeIds: badgeIds ?? this.badgeIds,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
