import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';

/// NicheSphere — Badges/Achievements Screen
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      {'emoji': '🌟', 'name': 'Explorer', 'desc': 'Joined 5+ events', 'unlocked': true, 'color': AppColors.neonOrange},
      {'emoji': '🎤', 'name': 'Host', 'desc': 'Created 1st event', 'unlocked': true, 'color': AppColors.neonPink},
      {'emoji': '🏗️', 'name': 'Builder', 'desc': 'Joined a Sphere', 'unlocked': true, 'color': AppColors.neonBlue},
      {'emoji': '🔥', 'name': 'Streak', 'desc': 'Active for 7 days', 'unlocked': false, 'color': AppColors.neonOrange},
      {'emoji': '🏆', 'name': 'Local Legend', 'desc': '10+ events in same city', 'unlocked': false, 'color': AppColors.neonPink},
      {'emoji': '🎯', 'name': 'Category Master', 'desc': '10 events in 1 category', 'unlocked': false, 'color': AppColors.neonBlue},
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RouteNames.profile);
      },
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg24),
                child: Row(children: [
                  GestureDetector(onTap: () => context.go(RouteNames.profile), child: const Icon(Icons.arrow_back_rounded)),
                  const SizedBox(width: AppSpacing.sm12),
                  Text('Your Achievements', style: AppTextStyles.displayL),
                ]),
              ).animate().fadeIn(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                child: Text('3 earned / ${badges.length} total', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: AppSpacing.md16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85),
                  itemCount: badges.length,
                  itemBuilder: (context, i) {
                    final b = badges[i];
                    final unlocked = b['unlocked'] as bool;
                    final color = b['color'] as Color;
                    return GlassCard(
                      blur: 10, opacity: unlocked ? 0.2 : 0.05, borderRadius: AppBorderRadius.xl,
                      glowColor: unlocked ? color : null,
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(b['emoji'] as String, style: TextStyle(fontSize: 40, 
                          color: unlocked ? Colors.white : Colors.white.withValues(alpha: 0.2))),
                        const SizedBox(height: 12),
                        Text(b['name'] as String, style: AppTextStyles.titleM.copyWith(
                          color: unlocked ? color : AppColors.textHint), textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(b['desc'] as String, style: AppTextStyles.micro.copyWith(
                          color: unlocked ? AppColors.textSecondary : AppColors.textHint), textAlign: TextAlign.center),
                        if (!unlocked) ...[
                          const SizedBox(height: 8),
                          const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textHint),
                        ],
                      ]),
                    ).animate().fadeIn(delay: Duration(milliseconds: 80 * i), duration: 300.ms)
                     .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
