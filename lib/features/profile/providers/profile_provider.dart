/// NicheSphere — Profile Provider (Phase 2)
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/user_model.dart';

/// Current user profile — real-time Firestore stream
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(userRepositoryProvider).watchCurrentUser();
});

/// Other user profile — by ID
final userProfileProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  final result = await ref.watch(userRepositoryProvider).getUserById(userId);
  return result.fold((_) => null, (user) => user);
});

/// Follow/Unfollow notifier
class FollowNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> follow(String targetUserId) async {
    state = const AsyncLoading();
    final result =
        await ref.read(userRepositoryProvider).followUser(targetUserId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> unfollow(String targetUserId) async {
    state = const AsyncLoading();
    final result =
        await ref.read(userRepositoryProvider).unfollowUser(targetUserId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final followNotifierProvider =
    AsyncNotifierProvider<FollowNotifier, void>(
        () => FollowNotifier());

/// Is following — real-time stream
final isFollowingProvider =
    StreamProvider.family<bool, String>((ref, targetUserId) {
  return ref.watch(userRepositoryProvider).watchIsFollowing(targetUserId);
});
