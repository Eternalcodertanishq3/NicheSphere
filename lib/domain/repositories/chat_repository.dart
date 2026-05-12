/// NicheSphere — Chat Repository Interface (Phase 2)
library;

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/message_model.dart';

/// Chat room model for watching user chat rooms
class ChatRoomModel {
  final String id;
  final String name;
  final String type;
  final String? eventId;
  final String? communityId;
  final List<String> memberIds;
  final String lastMessage;
  final DateTime lastMessageAt;
  final DateTime createdAt;

  const ChatRoomModel({
    required this.id,
    required this.name,
    required this.type,
    this.eventId,
    this.communityId,
    required this.memberIds,
    this.lastMessage = '',
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'event',
      eventId: json['eventId'] as String?,
      communityId: json['communityId'] as String?,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? (json['lastMessageAt'] as dynamic).toDate()
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}

abstract interface class ChatRepository {
  Stream<List<MessageModel>> watchMessages(String chatRoomId);
  Future<Either<Failure, Unit>> sendMessage(String chatRoomId, String content);
  Future<Either<Failure, Unit>> sendImageMessage(String chatRoomId, File image);
  Future<Either<Failure, Unit>> addReaction(
      String chatRoomId, String messageId, String emoji);
  Future<Either<Failure, String>> getOrCreateEventChatRoom(String eventId);
  Stream<List<ChatRoomModel>> watchUserChatRooms();
}
