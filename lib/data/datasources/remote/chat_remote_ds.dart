/// NicheSphere — Chat Remote DataSource (Phase 2)
library;

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/message_model.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../core/services/storage_service.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storage;

  ChatRemoteDataSource(this._storage);

  String get _uid => _auth.currentUser!.uid;
  String get _name => _auth.currentUser?.displayName ?? 'User';
  String? get _avatar => _auth.currentUser?.photoURL;

  Stream<List<MessageModel>> watchMessages(String chatRoomId) {
    return _db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(50)
        .snapshots()
        .map((s) => s.docs.map((d) => _messageFromFirestore(d)).toList());
  }

  Future<void> sendMessage(String chatRoomId, String content) async {
    final msgRef = _db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();
    final batch = _db.batch();
    batch.set(msgRef, {
      'id': msgRef.id,
      'chatRoomId': chatRoomId,
      'senderId': _uid,
      'senderName': _name,
      'senderAvatarUrl': _avatar,
      'content': content,
      'type': 'text',
      'sentAt': FieldValue.serverTimestamp(),
      'readBy': [_uid],
      'reactions': {},
    });
    batch.update(_db.collection('chatRooms').doc(chatRoomId), {
      'lastMessage': content,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  Future<void> sendImageMessage(String chatRoomId, File image) async {
    final urlResult = await _storage.uploadEventImage(image);
    final url = urlResult.fold((_) => null, (url) => url);
    if (url == null) return;

    final msgRef = _db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();
    await msgRef.set({
      'id': msgRef.id,
      'chatRoomId': chatRoomId,
      'senderId': _uid,
      'senderName': _name,
      'senderAvatarUrl': _avatar,
      'content': '📷 Image',
      'type': 'image',
      'imageUrl': url,
      'sentAt': FieldValue.serverTimestamp(),
      'readBy': [_uid],
      'reactions': {},
    });
  }

  Future<void> addReaction(
      String chatRoomId, String messageId, String emoji) async {
    await _db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'reactions.$_uid': emoji});
  }

  Future<String> getOrCreateEventChatRoom(String eventId) async {
    // Check if chat room exists for this event
    final existing = await _db
        .collection('chatRooms')
        .where('eventId', isEqualTo: eventId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) return existing.docs.first.id;

    // Create new chat room
    final ref = _db.collection('chatRooms').doc();
    await ref.set({
      'id': ref.id,
      'name': 'Event Chat',
      'type': 'event',
      'eventId': eventId,
      'memberIds': [_uid],
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<List<ChatRoomModel>> watchUserChatRooms() {
    return _db
        .collection('chatRooms')
        .where('memberIds', arrayContains: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => ChatRoomModel.fromJson(d.data())).toList());
  }

  MessageModel _messageFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel.fromJson({
      ...data,
      'id': doc.id,
      'sentAt': _timestampToString(data['sentAt']),
    });
  }

  String _timestampToString(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return DateTime.now().toIso8601String();
  }
}
