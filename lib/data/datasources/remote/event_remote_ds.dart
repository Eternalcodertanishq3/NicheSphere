/// NicheSphere — Event Remote DataSource (Phase 2)
/// All Firestore operations for events collection.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/event_model.dart';

class EventRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EventModel>> getFeaturedEvents() {
    return _db
        .collection('events')
        .where('isFeatured', isEqualTo: true)
        .where('status', isEqualTo: 'upcoming')
        .orderBy('startAt')
        .limit(10)
        .snapshots()
        .map((s) => s.docs.map((d) => _fromFirestore(d)).toList());
  }

  Stream<List<EventModel>> getNearbyEvents({
    required double lat,
    required double lng,
    String? category,
    int limitCount = 20,
  }) {
    Query<Map<String, dynamic>> query = _db
        .collection('events')
        .where('status', isEqualTo: 'upcoming')
        .orderBy('startAt')
        .limit(limitCount);
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    return query
        .snapshots()
        .map((s) => s.docs.map((d) => _fromFirestore(d)).toList());
  }

  Future<EventModel?> getEventById(String id) async {
    final doc = await _db.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  Future<List<EventModel>> searchEvents(String query,
      {String? category}) async {
    final q = _db
        .collection('events')
        .where('status', isEqualTo: 'upcoming')
        .orderBy('title')
        .startAt([query]).endAt(['$query\uf8ff']).limit(20);
    final snapshot = await q.get();
    return snapshot.docs.map((d) => _fromFirestore(d)).toList();
  }

  Future<String> createEvent(EventModel event) async {
    final ref = _db.collection('events').doc();
    final model = event.copyWith(id: ref.id);
    await ref.set(_toFirestore(model));
    return ref.id;
  }

  Future<void> rsvpEvent(String eventId, String userId) async {
    final batch = _db.batch();
    final rsvpRef = _db.collection('rsvps').doc('${userId}_$eventId');
    final eventRef = _db.collection('events').doc(eventId);

    batch.set(rsvpRef, {
      'id': '${userId}_$eventId',
      'userId': userId,
      'eventId': eventId,
      'status': 'attending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(eventRef, {
      'attendeeCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> cancelRsvp(String eventId, String userId) async {
    final batch = _db.batch();
    final rsvpRef = _db.collection('rsvps').doc('${userId}_$eventId');
    final eventRef = _db.collection('events').doc(eventId);

    batch.delete(rsvpRef);
    batch.update(eventRef, {
      'attendeeCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  Stream<bool> watchIsRsvped(String eventId, String userId) {
    return _db
        .collection('rsvps')
        .doc('${userId}_$eventId')
        .snapshots()
        .map((doc) => doc.exists && doc.data()?['status'] == 'attending');
  }

  Future<void> saveEvent(String eventId, String userId) async {
    await _db.collection('savedEvents').doc('${userId}_$eventId').set({
      'userId': userId,
      'eventId': eventId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsaveEvent(String eventId, String userId) async {
    await _db.collection('savedEvents').doc('${userId}_$eventId').delete();
  }

  Stream<bool> watchIsSaved(String eventId, String userId) {
    return _db
        .collection('savedEvents')
        .doc('${userId}_$eventId')
        .snapshots()
        .map((doc) => doc.exists);
  }

  // ── Firestore serialization helpers ──

  EventModel _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel.fromJson({
      ...data,
      'id': doc.id,
      'startAt': _timestampToString(data['startAt']),
      'endAt': _timestampToString(data['endAt']),
      'createdAt': _timestampToString(data['createdAt']),
    });
  }

  Map<String, dynamic> _toFirestore(EventModel event) {
    final json = event.toJson();
    json['startAt'] = Timestamp.fromDate(event.startAt);
    json['endAt'] = Timestamp.fromDate(event.endAt);
    json['createdAt'] = FieldValue.serverTimestamp();
    return json;
  }

  String _timestampToString(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return DateTime.now().toIso8601String();
  }
}
