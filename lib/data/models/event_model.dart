import 'package:flutter/foundation.dart' show immutable;

enum EventStatus { upcoming, live, ended, cancelled }
enum EventVisibility { public, friendsOnly, private }

@immutable
class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final DateTime startAt;
  final DateTime endAt;
  final String locationName;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<String> imageUrls;
  final int attendeeCount;
  final int maxAttendees;
  final bool isFree;
  final double? price;
  final String currency;
  final String organizerId;
  final String organizerName;
  final String? organizerAvatarUrl;
  final String? communityId;
  final EventStatus status;
  final EventVisibility visibility;
  final List<String> coHostIds;
  final double avgRating;
  final int reviewCount;
  final DateTime createdAt;
  final bool isFeatured;
  final String? liveStreamUrl;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.tags = const [],
    required this.startAt,
    required this.endAt,
    required this.locationName,
    required this.locationAddress,
    this.latitude = 0,
    this.longitude = 0,
    required this.imageUrl,
    this.imageUrls = const [],
    this.attendeeCount = 0,
    this.maxAttendees = 0,
    this.isFree = true,
    this.price,
    this.currency = 'USD',
    required this.organizerId,
    required this.organizerName,
    this.organizerAvatarUrl,
    this.communityId,
    this.status = EventStatus.upcoming,
    this.visibility = EventVisibility.public,
    this.coHostIds = const [],
    this.avgRating = 0,
    this.reviewCount = 0,
    required this.createdAt,
    this.isFeatured = false,
    this.liveStreamUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      startAt: parseDate(json['startAt']),
      endAt: parseDate(json['endAt']),
      locationName: json['locationName']?.toString() ?? '',
      locationAddress: json['locationAddress']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      imageUrls: json['imageUrls'] is List ? List<String>.from(json['imageUrls']) : [],
      attendeeCount: (json['attendeeCount'] as num?)?.toInt() ?? 0,
      maxAttendees: (json['maxAttendees'] as num?)?.toInt() ?? 0,
      isFree: json['isFree'] as bool? ?? true,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency']?.toString() ?? 'USD',
      organizerId: json['organizerId']?.toString() ?? '',
      organizerName: json['organizerName']?.toString() ?? '',
      organizerAvatarUrl: json['organizerAvatarUrl']?.toString(),
      communityId: json['communityId']?.toString(),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.upcoming,
      ),
      visibility: EventVisibility.values.firstWhere(
        (e) => e.name == json['visibility'],
        orElse: () => EventVisibility.public,
      ),
      coHostIds: json['coHostIds'] is List ? List<String>.from(json['coHostIds']) : [],
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      createdAt: parseDate(json['createdAt']),
      isFeatured: json['isFeatured'] as bool? ?? false,
      liveStreamUrl: json['liveStreamUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'tags': tags,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'locationName': locationName,
        'locationAddress': locationAddress,
        'latitude': latitude,
        'longitude': longitude,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'attendeeCount': attendeeCount,
        'maxAttendees': maxAttendees,
        'isFree': isFree,
        'price': price,
        'currency': currency,
        'organizerId': organizerId,
        'organizerName': organizerName,
        'organizerAvatarUrl': organizerAvatarUrl,
        'communityId': communityId,
        'status': status.name,
        'visibility': visibility.name,
        'coHostIds': coHostIds,
        'avgRating': avgRating,
        'reviewCount': reviewCount,
        'createdAt': createdAt.toIso8601String(),
        'isFeatured': isFeatured,
        'liveStreamUrl': liveStreamUrl,
      };

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? tags,
    DateTime? startAt,
    DateTime? endAt,
    String? locationName,
    String? locationAddress,
    double? latitude,
    double? longitude,
    String? imageUrl,
    List<String>? imageUrls,
    int? attendeeCount,
    int? maxAttendees,
    bool? isFree,
    double? price,
    String? currency,
    String? organizerId,
    String? organizerName,
    String? organizerAvatarUrl,
    String? communityId,
    EventStatus? status,
    EventVisibility? visibility,
    List<String>? coHostIds,
    double? avgRating,
    int? reviewCount,
    DateTime? createdAt,
    bool? isFeatured,
    String? liveStreamUrl,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerAvatarUrl: organizerAvatarUrl ?? this.organizerAvatarUrl,
      communityId: communityId ?? this.communityId,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      coHostIds: coHostIds ?? this.coHostIds,
      avgRating: avgRating ?? this.avgRating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
      liveStreamUrl: liveStreamUrl ?? this.liveStreamUrl,
    );
  }
}

