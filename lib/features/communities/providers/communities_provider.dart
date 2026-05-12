// NicheSphere — Communities Provider (Phase 2)
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/community_model.dart';

/// Popular communities stream
final communitiesListProvider = StreamProvider<List<CommunityModel>>((ref) {
  return ref.watch(communityRepositoryProvider).watchPopularCommunities();
});

/// User's joined communities stream
final userCommunitiesProvider = StreamProvider<List<CommunityModel>>((ref) {
  return ref.watch(communityRepositoryProvider).watchUserCommunities();
});

/// Join/Leave notifier
class CommunityActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> join(String communityId) async {
    state = const AsyncLoading();
    final result =
        await ref.read(communityRepositoryProvider).joinCommunity(communityId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> leave(String communityId) async {
    state = const AsyncLoading();
    final result =
        await ref.read(communityRepositoryProvider).leaveCommunity(communityId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final communityActionProvider =
    AsyncNotifierProvider<CommunityActionNotifier, void>(
        () => CommunityActionNotifier());
