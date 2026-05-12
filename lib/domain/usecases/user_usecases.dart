/// NicheSphere — User Use Cases (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository _repo;
  const GetUserProfile(this._repo);
  Future<Either<Failure, UserModel>> call(String userId) =>
      _repo.getUserById(userId);
}

class UpdateProfile {
  final UserRepository _repo;
  const UpdateProfile(this._repo);
  Future<Either<Failure, Unit>> call(Map<String, dynamic> fields) =>
      _repo.updateUser(fields);
}

class SaveInterests {
  final UserRepository _repo;
  const SaveInterests(this._repo);
  Future<Either<Failure, Unit>> call(List<String> interests) =>
      _repo.saveInterests(interests);
}

class FollowUser {
  final UserRepository _repo;
  const FollowUser(this._repo);
  Future<Either<Failure, Unit>> call(String targetUserId) =>
      _repo.followUser(targetUserId);
}

class UnfollowUser {
  final UserRepository _repo;
  const UnfollowUser(this._repo);
  Future<Either<Failure, Unit>> call(String targetUserId) =>
      _repo.unfollowUser(targetUserId);
}
