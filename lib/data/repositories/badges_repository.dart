import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class BadgeModel {
  final String emoji;
  final String name;
  final String desc;
  final bool unlocked;
  final Color color;

  const BadgeModel({
    required this.emoji,
    required this.name,
    required this.desc,
    required this.unlocked,
    required this.color,
  });
}

class BadgesRepository {
  Future<List<BadgeModel>> getBadges() async {
    // Simulated fetch from local or remote
    return [
      const BadgeModel(emoji: '🌟', name: 'Explorer', desc: 'Joined 5+ events', unlocked: true, color: AppColors.neonOrange),
      const BadgeModel(emoji: '🎤', name: 'Host', desc: 'Created 1st event', unlocked: true, color: AppColors.neonPink),
      const BadgeModel(emoji: '🏗️', name: 'Builder', desc: 'Joined a Sphere', unlocked: true, color: AppColors.neonBlue),
      const BadgeModel(emoji: '🔥', name: 'Streak', desc: 'Active for 7 days', unlocked: false, color: AppColors.neonOrange),
      const BadgeModel(emoji: '🏆', name: 'Local Legend', desc: '10+ events in same city', unlocked: false, color: AppColors.neonPink),
      const BadgeModel(emoji: '🎯', name: 'Category Master', desc: '10 events in 1 category', unlocked: false, color: AppColors.neonBlue),
    ];
  }
}

final badgesRepositoryProvider = Provider((ref) => BadgesRepository());

final badgesProvider = FutureProvider<List<BadgeModel>>((ref) async {
  return ref.watch(badgesRepositoryProvider).getBadges();
});
