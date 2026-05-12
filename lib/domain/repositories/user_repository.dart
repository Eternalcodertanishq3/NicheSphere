/// NicheSphere — User Repository Interface (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract interface class UserRepository {
  Future<Either<Failure, Unit>> createUserDocument(UserModel user);
  Future<Either<Failure, UserModel>> getUserById(String id);
  Stream<UserModel?> watchCurrentUser();
  Future<Either<Failure, Unit>> updateUser(Map<String, dynamic> fields);
  Future<Either<Failure, Unit>> saveInterests(List<String> interests);
  Future<Either<Failure, Unit>> followUser(String targetUserId);
  Future<Either<Failure, Unit>> unfollowUser(String targetUserId);
  Stream<bool> watchIsFollowing(String targetUserId);
  Future<Either<Failure, bool>> isUsernameAvailable(String username);
}
