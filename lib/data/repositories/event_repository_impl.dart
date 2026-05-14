/// NicheSphere — Event Repository Implementation (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/remote/event_remote_ds.dart';
import '../datasources/local/event_local_ds.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _remote;
  final EventLocalDataSource _local;
  final FirebaseAuth _auth;

  const EventRepositoryImpl(this._remote, this._local, this._auth);

  String? get _uid => _auth.currentUser?.uid;

  Failure _authFailure() => const AuthFailure('User must be logged in');

  @override
  Stream<List<EventModel>> watchFeaturedEvents() async* {
    try {
      await for (final events in _remote.getFeaturedEvents()) {
        _local.cacheEvents(events);
        yield events;
      }
    } catch (e) {
      final cached = _local.getCachedEvents();
      if (cached.isNotEmpty) {
        yield cached;
      } else {
        // Log error but yield empty to prevent UI crash
        yield <EventModel>[];
      }
    }
  }

  @override
  Stream<List<EventModel>> watchNearbyEvents(
      {required double lat, required double lng, String? category}) async* {
    try {
      await for (final events in _remote.getNearbyEvents(lat: lat, lng: lng, category: category)) {
        _local.cacheNearbyEvents(events);
        yield events;
      }
    } catch (e) {
      final cached = _local.getCachedNearbyEvents();
      if (cached.isNotEmpty) {
        yield cached;
      } else {
        yield <EventModel>[];
      }
    }
  }

  @override
  Future<Either<Failure, EventModel>> getEventById(String id) async {
    try {
      final event = await _remote.getEventById(id);
      if (event == null) return const Left(NotFoundFailure());
      return Right(event);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> searchEvents(String query,
      {String? category}) async {
    try {
      final results = await _remote.searchEvents(query, category: category);
      return Right(results);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> createEvent(EventModel event) async {
    final uid = _uid;
    if (uid == null) return Left(_authFailure());
    
    try {
      final id = await _remote.createEvent(event.copyWith(organizerId: uid));
      return Right(id);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> rsvpEvent(String eventId) async {
    final uid = _uid;
    if (uid == null) return Left(_authFailure());

    try {
      await _remote.rsvpEvent(eventId, uid);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelRsvp(String eventId) async {
    final uid = _uid;
    if (uid == null) return Left(_authFailure());

    try {
      await _remote.cancelRsvp(eventId, uid);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveEvent(String eventId) async {
    final uid = _uid;
    if (uid == null) return Left(_authFailure());

    try {
      await _remote.saveEvent(eventId, uid);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsaveEvent(String eventId) async {
    final uid = _uid;
    if (uid == null) return Left(_authFailure());

    try {
      await _remote.unsaveEvent(eventId, uid);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Stream<bool> watchIsRsvped(String eventId) {
    final uid = _uid;
    if (uid == null) return Stream.value(false);
    return _remote.watchIsRsvped(eventId, uid);
  }

  @override
  Stream<bool> watchIsSaved(String eventId) {
    final uid = _uid;
    if (uid == null) return Stream.value(false);
    return _remote.watchIsSaved(eventId, uid);
  }
}
