/// NicheSphere — Event Use Cases (Phase 2)
/// All event-related use cases in a single file for maintainability.
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/event_model.dart';
import '../repositories/event_repository.dart';

class GetFeaturedEvents {
  final EventRepository _repo;
  const GetFeaturedEvents(this._repo);
  Stream<List<EventModel>> call() => _repo.watchFeaturedEvents();
}

class GetNearbyEvents {
  final EventRepository _repo;
  const GetNearbyEvents(this._repo);
  Stream<List<EventModel>> call(
          {required double lat, required double lng, String? category}) =>
      _repo.watchNearbyEvents(lat: lat, lng: lng, category: category);
}

class GetEventById {
  final EventRepository _repo;
  const GetEventById(this._repo);
  Future<Either<Failure, EventModel>> call(String id) => _repo.getEventById(id);
}

class SearchEvents {
  final EventRepository _repo;
  const SearchEvents(this._repo);
  Future<Either<Failure, List<EventModel>>> call(String query,
          {String? category}) =>
      _repo.searchEvents(query, category: category);
}

class CreateEvent {
  final EventRepository _repo;
  const CreateEvent(this._repo);
  Future<Either<Failure, String>> call(EventModel event) =>
      _repo.createEvent(event);
}

class RsvpEvent {
  final EventRepository _repo;
  const RsvpEvent(this._repo);
  Future<Either<Failure, Unit>> call(String eventId) =>
      _repo.rsvpEvent(eventId);
}

class CancelRsvp {
  final EventRepository _repo;
  const CancelRsvp(this._repo);
  Future<Either<Failure, Unit>> call(String eventId) =>
      _repo.cancelRsvp(eventId);
}

class SaveEvent {
  final EventRepository _repo;
  const SaveEvent(this._repo);
  Future<Either<Failure, Unit>> call(String eventId) =>
      _repo.saveEvent(eventId);
}
