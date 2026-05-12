// NicheSphere — Chat Provider (Phase 2)
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/message_model.dart';
import '../../../domain/repositories/chat_repository.dart';

/// Messages stream for a chat room
final chatMessagesProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatRoomId) {
  return ref.watch(chatRepositoryProvider).watchMessages(chatRoomId);
});

/// User's chat rooms stream
final userChatRoomsProvider =
    StreamProvider<List<ChatRoomModel>>((ref) {
  return ref.watch(chatRepositoryProvider).watchUserChatRooms();
});

/// Send message notifier

class SendMessageNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> send(String chatRoomId, String content) async {
    state = const AsyncLoading();
    final result = await ref
        .read(chatRepositoryProvider)
        .sendMessage(chatRoomId, content);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final sendMessageNotifierProvider =
    AsyncNotifierProvider<SendMessageNotifier, void>(
        () => SendMessageNotifier());
