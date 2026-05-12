/// NicheSphere — User Repository Implementation (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_ds.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;

  const UserRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, Unit>> createUserDocument(UserModel user) async {
    try {
      await _remote.createUserDocument(user);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) async {
    try {
      final user = await _remote.getUserById(id);
      if (user == null) return const Left(NotFoundFailure());
      return Right(user);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Stream<UserModel?> watchCurrentUser() {
    return _remote.watchCurrentUser();
  }

  @override
  Future<Either<Failure, Unit>> updateUser(Map<String, dynamic> fields) async {
    try {
      await _remote.updateUser(fields);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveInterests(List<String> interests) async {
    try {
      await _remote.saveInterests(interests);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> followUser(String targetUserId) async {
    try {
      await _remote.followUser(targetUserId);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> unfollowUser(String targetUserId) async {
    try {
      await _remote.unfollowUser(targetUserId);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Stream<bool> watchIsFollowing(String targetUserId) {
    return _remote.watchIsFollowing(targetUserId);
  }

  @override
  Future<Either<Failure, bool>> isUsernameAvailable(String username) async {
    try {
      final available = await _remote.isUsernameAvailable(username);
      return Right(available);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
