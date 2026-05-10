import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';

/// NicheSphere — Badges Screen (Screen 19)
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      {'emoji': '🌟', 'name': 'Explorer I', 'desc': 'Attend 1 event', 'unlocked': true, 'color': AppColors.neonOrange},
      {'emoji': '🎤', 'name': 'Host I', 'desc': 'Host 1 event', 'unlocked': true, 'color': AppColors.neonPink},
      {'emoji': '🏗️', 'name': 'Builder I', 'desc': 'Join 3 communities', 'unlocked': true, 'color': AppColors.neonBlue},
      {'emoji': '🦋', 'name': 'Social Butterfly', 'desc': 'Follow 10 users', 'unlocked': false, 'color': AppColors.neonPurple},
      {'emoji': '🔥', 'name': 'Trendsetter', 'desc': '50 attendees at your event', 'unlocked': false, 'color': AppColors.neonOrange},
      {'emoji': '🐦', 'name': 'Early Bird', 'desc': 'RSVP >7 days before', 'unlocked': false, 'color': AppColors.neonGreen},
      {'emoji': '🏆', 'name': 'Local Legend', 'desc': '10+ events in same city', 'unlocked': false, 'color': AppColors.neonPink},
      {'emoji': '🎯', 'name': 'Category Master', 'desc': '10 events in 1 category', 'unlocked': false, 'color': AppColors.neonBlue},
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
                itemCount: badges.length,
                itemBuilder: (_, i) {
                  final b = badges[i];
                  final unlocked = b['unlocked'] as bool;
                  final color = b['color'] as Color;
                  return GlassCard(
                    blur: 12, opacity: unlocked ? 0.2 : 0.1, borderRadius: AppBorderRadius.lg,
                    glowColor: unlocked ? color : null,
                    padding: const EdgeInsets.all(AppSpacing.md16),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(b['emoji'] as String, style: TextStyle(fontSize: 40,
                        color: unlocked ? null : Colors.grey)),
                      const SizedBox(height: 8),
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
    );
  }
}
