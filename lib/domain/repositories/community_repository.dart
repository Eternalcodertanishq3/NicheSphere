/// NicheSphere — Community Repository Interface (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/community_model.dart';

abstract interface class CommunityRepository {
  Stream<List<CommunityModel>> watchPopularCommunities();
  Stream<List<CommunityModel>> watchUserCommunities();
  Future<Either<Failure, CommunityModel>> getCommunityById(String id);
  Future<Either<Failure, Unit>> joinCommunity(String communityId);
  Future<Either<Failure, Unit>> leaveCommunity(String communityId);
  Stream<bool> watchIsMember(String communityId);
  Future<Either<Failure, String>> createCommunity(CommunityModel community);
}
