/// NicheSphere — Chat Use Cases (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/message_model.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository _repo;
  const SendMessage(this._repo);
  Future<Either<Failure, Unit>> call(String chatRoomId, String content) =>
      _repo.sendMessage(chatRoomId, content);
}

class GetChatMessages {
  final ChatRepository _repo;
  const GetChatMessages(this._repo);
  Stream<List<MessageModel>> call(String chatRoomId) =>
      _repo.watchMessages(chatRoomId);
}
