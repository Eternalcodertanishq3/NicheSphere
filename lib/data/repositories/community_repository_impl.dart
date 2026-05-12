/// NicheSphere — Community Repository Implementation (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/remote/community_remote_ds.dart';
import '../models/community_model.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remote;

  const CommunityRepositoryImpl(this._remote);

  @override
  Stream<List<CommunityModel>> watchPopularCommunities() {
    return _remote
        .getPopularCommunities()
        .handleError((_) => <CommunityModel>[]);
  }

  @override
  Stream<List<CommunityModel>> watchUserCommunities() {
    return _remote.getUserCommunities().handleError((_) => <CommunityModel>[]);
  }

  @override
  Future<Either<Failure, CommunityModel>> getCommunityById(String id) async {
    try {
      final community = await _remote.getCommunityById(id);
      if (community == null) return const Left(NotFoundFailure());
      return Right(community);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinCommunity(String communityId) async {
    try {
      await _remote.joinCommunity(communityId);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> leaveCommunity(String communityId) async {
    try {
      await _remote.leaveCommunity(communityId);
      return const Right(unit);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Stream<bool> watchIsMember(String communityId) {
    return _remote.watchIsMember(communityId);
  }

  @override
  Future<Either<Failure, String>> createCommunity(
      CommunityModel community) async {
    try {
      final id = await _remote.createCommunity(community);
      return Right(id);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
