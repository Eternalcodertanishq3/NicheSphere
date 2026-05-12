/// NicheSphere — Chat Repository Implementation (Phase 2)
library;

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_ds.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;

  const ChatRepositoryImpl(this._remote);

  @override
  Stream<List<MessageModel>> watchMessages(String chatRoomId) {
    return _remote.watchMessages(chatRoomId);
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(
      String chatRoomId, String content) async {
    try {
      await _remote.sendMessage(chatRoomId, content);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendImageMessage(
      String chatRoomId, File image) async {
    try {
      await _remote.sendImageMessage(chatRoomId, image);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addReaction(
      String chatRoomId, String messageId, String emoji) async {
    try {
      await _remote.addReaction(chatRoomId, messageId, emoji);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> getOrCreateEventChatRoom(
      String eventId) async {
    try {
      final id = await _remote.getOrCreateEventChatRoom(eventId);
      return Right(id);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Stream<List<ChatRoomModel>> watchUserChatRooms() {
    return _remote.watchUserChatRooms();
  }
}
