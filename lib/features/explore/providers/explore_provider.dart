/// NicheSphere — Explore Provider (Phase 2)
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';

/// Search query state
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void update(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
    () => SearchQueryNotifier());

/// Search results
final searchResultsProvider = FutureProvider<List<EventModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final result = await ref.watch(eventRepositoryProvider).searchEvents(query);
  return result.fold((_) => [], (events) => events);
});

/// All upcoming events for browse mode
final allEventsProvider = StreamProvider<List<EventModel>>((ref) {
  return ref
      .watch(eventRepositoryProvider)
      .watchNearbyEvents(lat: 0, lng: 0); // fallback browse mode
});
