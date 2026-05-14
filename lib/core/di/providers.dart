/// NicheSphere — Dependency Injection Providers (Phase 2)
/// Central provider file for all services, datasources, repositories, and use cases.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../../data/datasources/remote/event_remote_ds.dart';
import '../../data/datasources/remote/user_remote_ds.dart';
import '../../data/datasources/remote/community_remote_ds.dart';
import '../../data/datasources/remote/chat_remote_ds.dart';
import '../../data/datasources/local/event_local_ds.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/event_usecases.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../domain/usecases/community_usecases.dart';
import '../../domain/usecases/chat_usecases.dart';

// ── Firebase ────────────────────────────────────────
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// ── Services ────────────────────────────────────────
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final analyticsServiceProvider =
    Provider<AnalyticsService>((ref) => AnalyticsService());
final locationServiceProvider =
    Provider<LocationService>((ref) => LocationService());
final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

// ── Firebase Auth stream ─────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// ── Datasources ──────────────────────────────────────
final eventRemoteDsProvider =
    Provider<EventRemoteDataSource>((ref) => EventRemoteDataSource());
final userRemoteDsProvider =
    Provider<UserRemoteDataSource>((ref) => UserRemoteDataSource());
final communityRemoteDsProvider =
    Provider<CommunityRemoteDataSource>((ref) => CommunityRemoteDataSource());
final chatRemoteDsProvider = Provider<ChatRemoteDataSource>(
    (ref) => ChatRemoteDataSource(ref.watch(storageServiceProvider)));
final eventLocalDsProvider =
    Provider<EventLocalDataSource>((ref) => EventLocalDataSource());

// ── Repositories ─────────────────────────────────────
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(
    ref.watch(eventRemoteDsProvider),
    ref.watch(eventLocalDsProvider),
    ref.watch(firebaseAuthProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.watch(userRemoteDsProvider),
  );
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(
    ref.watch(communityRemoteDsProvider),
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDsProvider),
  );
});

// ── Event Use Cases ──────────────────────────────────
final getFeaturedEventsProvider = Provider<GetFeaturedEvents>(
    (ref) => GetFeaturedEvents(ref.watch(eventRepositoryProvider)));
final getNearbyEventsProvider = Provider<GetNearbyEvents>(
    (ref) => GetNearbyEvents(ref.watch(eventRepositoryProvider)));
final getEventByIdProvider = Provider<GetEventById>(
    (ref) => GetEventById(ref.watch(eventRepositoryProvider)));
final searchEventsProvider = Provider<SearchEvents>(
    (ref) => SearchEvents(ref.watch(eventRepositoryProvider)));
final createEventProvider = Provider<CreateEvent>(
    (ref) => CreateEvent(ref.watch(eventRepositoryProvider)));
final rsvpEventProvider =
    Provider<RsvpEvent>((ref) => RsvpEvent(ref.watch(eventRepositoryProvider)));
final cancelRsvpProvider = Provider<CancelRsvp>(
    (ref) => CancelRsvp(ref.watch(eventRepositoryProvider)));
final saveEventProvider =
    Provider<SaveEvent>((ref) => SaveEvent(ref.watch(eventRepositoryProvider)));

// ── User Use Cases ───────────────────────────────────
final getUserProfileProvider = Provider<GetUserProfile>(
    (ref) => GetUserProfile(ref.watch(userRepositoryProvider)));
final updateProfileProvider = Provider<UpdateProfile>(
    (ref) => UpdateProfile(ref.watch(userRepositoryProvider)));
final saveInterestsProvider = Provider<SaveInterests>(
    (ref) => SaveInterests(ref.watch(userRepositoryProvider)));
final followUserProvider = Provider<FollowUser>(
    (ref) => FollowUser(ref.watch(userRepositoryProvider)));
final unfollowUserProvider = Provider<UnfollowUser>(
    (ref) => UnfollowUser(ref.watch(userRepositoryProvider)));

// ── Community Use Cases ──────────────────────────────
final getCommunitiesProvider = Provider<GetCommunities>(
    (ref) => GetCommunities(ref.watch(communityRepositoryProvider)));
final joinCommunityProvider = Provider<JoinCommunity>(
    (ref) => JoinCommunity(ref.watch(communityRepositoryProvider)));
final leaveCommunityProvider = Provider<LeaveCommunity>(
    (ref) => LeaveCommunity(ref.watch(communityRepositoryProvider)));
final createCommunityProvider = Provider<CreateCommunity>(
    (ref) => CreateCommunity(ref.watch(communityRepositoryProvider)));

// ── Chat Use Cases ───────────────────────────────────
final sendMessageProvider = Provider<SendMessage>(
    (ref) => SendMessage(ref.watch(chatRepositoryProvider)));
final getChatMessagesProvider = Provider<GetChatMessages>(
    (ref) => GetChatMessages(ref.watch(chatRepositoryProvider)));
