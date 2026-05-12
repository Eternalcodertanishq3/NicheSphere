/// NicheSphere — Community Remote DataSource (Phase 2)
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/community_model.dart';

class CommunityRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Stream<List<CommunityModel>> getPopularCommunities() {
    return _db
        .collection('communities')
        .orderBy('activityScore', descending: true)
        .limit(20)
        .snapshots()
        .map((s) => s.docs.map((d) => _fromFirestore(d)).toList());
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    return _db
        .collection('communityMembers')
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .asyncMap((memberSnap) async {
      final ids = memberSnap.docs
          .map((d) => d.data()['communityId'] as String)
          .toList();
      if (ids.isEmpty) return <CommunityModel>[];
      final commSnap = await _db
          .collection('communities')
          .where(FieldPath.documentId, whereIn: ids.take(10).toList())
          .get();
      return commSnap.docs.map((d) => _fromFirestore(d)).toList();
    });
  }

  Future<CommunityModel?> getCommunityById(String id) async {
    final doc = await _db.collection('communities').doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  Future<void> joinCommunity(String communityId) async {
    final batch = _db.batch();
    batch.set(
      _db.collection('communityMembers').doc('${communityId}_$_uid'),
      {
        'communityId': communityId,
        'userId': _uid,
        'role': 'member',
        'joinedAt': FieldValue.serverTimestamp(),
      },
    );
    batch.update(_db.collection('communities').doc(communityId), {
      'memberCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> leaveCommunity(String communityId) async {
    final batch = _db.batch();
    batch
        .delete(_db.collection('communityMembers').doc('${communityId}_$_uid'));
    batch.update(_db.collection('communities').doc(communityId), {
      'memberCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  Stream<bool> watchIsMember(String communityId) {
    return _db
        .collection('communityMembers')
        .doc('${communityId}_$_uid')
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<String> createCommunity(CommunityModel community) async {
    final ref = _db.collection('communities').doc();
    await ref.set({
      ..._toFirestore(community),
      'id': ref.id,
      'creatorId': _uid,
      'adminIds': [_uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
    // Auto-join creator
    await joinCommunity(ref.id);
    return ref.id;
  }

  CommunityModel _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityModel.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': _timestampToString(data['createdAt']),
    });
  }

  Map<String, dynamic> _toFirestore(CommunityModel c) {
    final json = c.toJson();
    json.remove('createdAt');
    return json;
  }

  String _timestampToString(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return DateTime.now().toIso8601String();
  }
}
