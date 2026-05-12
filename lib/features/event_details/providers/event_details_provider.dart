// NicheSphere — Event Details Provider (Phase 2)
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';

/// Single event details — fetched by ID
final eventDetailsProvider =
    FutureProvider.family<EventModel, String>((ref, eventId) async {
  final result = await ref.watch(eventRepositoryProvider).getEventById(eventId);
  return result.fold((f) => throw f.message, (e) => e);
});

/// Real-time RSVP status
final isRsvpedProvider = StreamProvider.family<bool, String>((ref, eventId) {
  return ref.watch(eventRepositoryProvider).watchIsRsvped(eventId);
});

/// Real-time saved status
final isSavedProvider = StreamProvider.family<bool, String>((ref, eventId) {
  return ref.watch(eventRepositoryProvider).watchIsSaved(eventId);
});

/// RSVP action notifier

class RsvpNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> rsvp(String eventId) async {
    state = const AsyncLoading();
    final result = await ref.read(eventRepositoryProvider).rsvpEvent(eventId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> cancel(String eventId) async {
    state = const AsyncLoading();
    final result = await ref.read(eventRepositoryProvider).cancelRsvp(eventId);
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final rsvpNotifierProvider =
    AsyncNotifierProvider<RsvpNotifier, void>(() => RsvpNotifier());
