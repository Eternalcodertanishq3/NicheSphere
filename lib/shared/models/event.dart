import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startAt;
  final String locationName;
  final double lat;
  final double lng;
  final String imageUrl;
  final int attendeeCount;
  final String organizerName;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startAt,
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.imageUrl,
    required this.attendeeCount,
    required this.organizerName,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      startAt: (data['startAt'] as Timestamp).toDate(),
      locationName: data['location']['address'] ?? '',
      lat: data['location']['lat'] ?? 0.0,
      lng: data['location']['lng'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      attendeeCount: data['attendeeCount'] ?? 0,
      organizerName: data['organizerName'] ?? 'Anonymous',
    );
  }
}
