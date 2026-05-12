/// NicheSphere — User Remote DataSource (Phase 2)
/// All Firestore operations for users collection.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<void> createUserDocument(UserModel user) async {
    await _db.collection('users').doc(user.id).set({
      ...user.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  Stream<UserModel?> watchCurrentUser() {
    return _db.collection('users').doc(_uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    });
  }

  Future<void> updateUser(Map<String, dynamic> fields) async {
    await _db.collection('users').doc(_uid).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveInterests(List<String> interests) async {
    await _db.collection('users').doc(_uid).update({'interests': interests});
  }

  Future<void> followUser(String targetId) async {
    final batch = _db.batch();
    batch.set(
      _db.collection('follows').doc('${_uid}_$targetId'),
      {
        'followerId': _uid,
        'followingId': targetId,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
    batch.update(_db.collection('users').doc(_uid),
        {'followingCount': FieldValue.increment(1)});
    batch.update(_db.collection('users').doc(targetId),
        {'followersCount': FieldValue.increment(1)});
    await batch.commit();
  }

  Future<void> unfollowUser(String targetId) async {
    final batch = _db.batch();
    batch.delete(_db.collection('follows').doc('${_uid}_$targetId'));
    batch.update(_db.collection('users').doc(_uid),
        {'followingCount': FieldValue.increment(-1)});
    batch.update(_db.collection('users').doc(targetId),
        {'followersCount': FieldValue.increment(-1)});
    await batch.commit();
  }

  Stream<bool> watchIsFollowing(String targetId) {
    return _db
        .collection('follows')
        .doc('${_uid}_$targetId')
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<bool> isUsernameAvailable(String username) async {
    final q = await _db
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return q.docs.isEmpty;
  }

  UserModel _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': _timestampToString(data['createdAt']),
    });
  }

  String _timestampToString(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return DateTime.now().toIso8601String();
  }
}
