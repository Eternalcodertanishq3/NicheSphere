/// NicheSphere — Event Repository Interface (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/event_model.dart';

abstract interface class EventRepository {
  Stream<List<EventModel>> watchFeaturedEvents();
  Stream<List<EventModel>> watchNearbyEvents(
      {required double lat, required double lng, String? category});
  Future<Either<Failure, EventModel>> getEventById(String id);
  Future<Either<Failure, List<EventModel>>> searchEvents(String query,
      {String? category});
  Future<Either<Failure, String>> createEvent(EventModel event);
  Future<Either<Failure, Unit>> rsvpEvent(String eventId);
  Future<Either<Failure, Unit>> cancelRsvp(String eventId);
  Future<Either<Failure, Unit>> saveEvent(String eventId);
  Future<Either<Failure, Unit>> unsaveEvent(String eventId);
  Stream<bool> watchIsRsvped(String eventId);
  Stream<bool> watchIsSaved(String eventId);
}
