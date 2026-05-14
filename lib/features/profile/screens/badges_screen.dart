import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/repositories/badges_repository.dart';
import '../../../shared/widgets/glass_empty_state.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_border_radius.dart';

/// NicheSphere — Badges/Achievements Screen
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RouteNames.profile);
      },
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: badgesAsync.when(
              data: (badges) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg24),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => context.go(RouteNames.profile),
                      child: GlassCard(
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(12),
                        opacity: 0.1,
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm12),
                    Text('Your Achievements', style: AppTextStyles.displayL),
                  ]),
                ).animate().fadeIn(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                  child: Text(
                    '${badges.where((b) => b.unlocked).length} earned / ${badges.length} total',
                    style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
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
                      return GlassCard(
                        blur: 10, opacity: b.unlocked ? 0.2 : 0.05, borderRadius: AppBorderRadius.xl,
                        glowColor: b.unlocked ? b.color : null,
                        padding: const EdgeInsets.all(16),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(b.emoji, style: TextStyle(fontSize: 40, 
                            color: b.unlocked ? Colors.white : Colors.white.withValues(alpha: 0.2))),
                          const SizedBox(height: 12),
                          Text(b.name, style: AppTextStyles.titleM.copyWith(
                            color: b.unlocked ? b.color : AppColors.textHint), textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text(b.desc, style: AppTextStyles.micro.copyWith(
                            color: b.unlocked ? AppColors.textSecondary : AppColors.textHint), textAlign: TextAlign.center),
                          if (!b.unlocked) ...[
                            const SizedBox(height: 8),
                            const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textHint),
                          ],
                        ]),
                      ).animate().fadeIn(delay: (80 * i).ms, duration: 300.ms)
                       .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
                    },
                  ),
                ),
              ]),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Center(child: GlassEmptyState(
                title: 'Oops!', 
                message: 'Failed to load achievements',
                icon: Icons.error_outline_rounded,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
