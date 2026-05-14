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
import '../../../shared/widgets/app_back_button.dart';

/// NicheSphere — Notifications Screen (Screen 16)
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'icon': Icons.check_circle_rounded, 'text': 'Sarah RSVPed to your Indie Game Meetup', 'time': '2m ago', 'color': AppColors.success},
      {'icon': Icons.alarm_rounded, 'text': 'Sunset Yoga starts in 24 hours!', 'time': '1h ago', 'color': AppColors.warning},
      {'icon': Icons.person_add_rounded, 'text': 'Maya started following you', 'time': '3h ago', 'color': AppColors.neonBlue},
      {'icon': Icons.comment_rounded, 'text': 'New comment on Watercolor Workshop', 'time': '5h ago', 'color': AppColors.neonPurple},
      {'icon': Icons.trending_up_rounded, 'text': 'Coffee Tasting Tour is almost full!', 'time': '1d ago', 'color': AppColors.neonOrange},
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                AppBackButton(onTap: () => context.go(RouteNames.home)),
                const SizedBox(width: AppSpacing.sm12),
                Text('Notifications', style: AppTextStyles.displayL),
                const Spacer(),
                Text('Mark all read', style: AppTextStyles.label.copyWith(color: AppColors.neonPink)),
              ]),
            ).animate().fadeIn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: Text('Today', style: AppTextStyles.titleM.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: AppSpacing.xs8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final n = notifications[i];
                  return Dismissible(
                    key: ValueKey(i),
                    background: Container(
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.2), borderRadius: AppBorderRadius.lg),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                    ),
                    direction: DismissDirection.endToStart,
                    child: GlassCard(blur: 12, opacity: 0.2, borderRadius: AppBorderRadius.lg,
                      padding: const EdgeInsets.all(AppSpacing.sm12),
                      child: Row(children: [
                        Container(width: 40, height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: (n['color'] as Color).withValues(alpha: 0.15)),
                          child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20)),
                        const SizedBox(width: AppSpacing.sm12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(n['text'] as String, style: AppTextStyles.bodyM, maxLines: 2),
                          const SizedBox(height: 2),
                          Text(n['time'] as String, style: AppTextStyles.micro),
                        ])),
                      ])),
                  ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 300.ms).slideX(begin: 0.05, end: 0);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
