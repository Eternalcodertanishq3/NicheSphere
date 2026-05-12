/// NicheSphere — Community Use Cases (Phase 2)
library;

import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../data/models/community_model.dart';
import '../repositories/community_repository.dart';

class GetCommunities {
  final CommunityRepository _repo;
  const GetCommunities(this._repo);
  Stream<List<CommunityModel>> call() => _repo.watchPopularCommunities();
}

class JoinCommunity {
  final CommunityRepository _repo;
  const JoinCommunity(this._repo);
  Future<Either<Failure, Unit>> call(String communityId) =>
      _repo.joinCommunity(communityId);
}

class LeaveCommunity {
  final CommunityRepository _repo;
  const LeaveCommunity(this._repo);
  Future<Either<Failure, Unit>> call(String communityId) =>
      _repo.leaveCommunity(communityId);
}

class CreateCommunity {
  final CommunityRepository _repo;
  const CreateCommunity(this._repo);
  Future<Either<Failure, String>> call(CommunityModel community) =>
      _repo.createCommunity(community);
}
