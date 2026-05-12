/// NicheSphere — Location Service (Phase 2)
/// Wraps Geolocator for location permission + current position.
library;

import 'package:geolocator/geolocator.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

class LocationService {
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return Left(const PermissionFailure());

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(const PermissionFailure());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Left(const PermissionFailure());
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return Right(position);
    } catch (e) {
      return Left(const UnknownFailure());
    }
  }
}
