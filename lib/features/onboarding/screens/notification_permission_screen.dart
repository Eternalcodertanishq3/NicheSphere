import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Notification Permission Screen (Screen 5)
class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [AppColors.neonOrange, AppColors.neonPink]),
                    boxShadow: [BoxShadow(color: AppColors.neonOrange.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.notifications_rounded, size: 40, color: Colors.white),
                ).animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut)
                 .then().shake(hz: 3, rotation: 0.05, duration: 500.ms),
                const SizedBox(height: AppSpacing.xl48),
                Text('Stay in the loop', style: AppTextStyles.displayL, textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppSpacing.sm12),
                Text('Get notified about events, RSVPs,\nand community updates',
                    style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 500.ms, duration: 400.ms),
                const Spacer(),
                AppButton(label: 'Enable Notifications', icon: Icons.notifications_active_rounded,
                    onTap: () => context.go(RouteNames.login)),
                const SizedBox(height: AppSpacing.md16),
                TextButton(onPressed: () => context.go(RouteNames.login),
                    child: Text('Maybe later', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary))),
                const SizedBox(height: AppSpacing.lg32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
