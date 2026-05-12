/// NicheSphere — Home Provider (Phase 2)
library;

/// Real-time streams for featured events, nearby events, communities.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/community_model.dart';

/// Featured events — real-time Firestore stream
final featuredEventsProvider = StreamProvider<List<EventModel>>((ref) {
  return ref.watch(eventRepositoryProvider).watchFeaturedEvents();
});

/// User location
final userLocationProvider = FutureProvider<Position>((ref) async {
  final result = await ref.watch(locationServiceProvider).getCurrentLocation();
  return result.fold(
    (_) => throw Exception('Location unavailable'),
    (pos) => pos,
  );
});

/// Nearby events — real-time stream filtered by user location
final nearbyEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final location = ref.watch(userLocationProvider);
  return location.when(
    data: (pos) => ref.watch(eventRepositoryProvider).watchNearbyEvents(
          lat: pos.latitude,
          lng: pos.longitude,
        ),
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

/// Popular communities stream
final popularCommunitiesProvider = StreamProvider<List<CommunityModel>>((ref) {
  return ref.watch(communityRepositoryProvider).watchPopularCommunities();
});

/// Selected category filter
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';
  void select(String category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
        () => SelectedCategoryNotifier());
