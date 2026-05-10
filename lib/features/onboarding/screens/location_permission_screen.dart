import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Location Permission Screen (Screen 4)
class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

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
                    gradient: const LinearGradient(colors: [AppColors.neonBlue, AppColors.neonPurple]),
                    boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.location_on_rounded, size: 40, color: Colors.white),
                ).animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: AppSpacing.xl48),
                Text('Find events near you', style: AppTextStyles.displayL, textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppSpacing.sm12),
                Text('Allow location access to see what\'s\nhappening in your neighborhood',
                    style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 500.ms, duration: 400.ms),
                const Spacer(),
                AppButton(label: 'Allow Location', icon: Icons.my_location_rounded,
                    onTap: () => context.go(RouteNames.notificationPermission)),
                const SizedBox(height: AppSpacing.md16),
                TextButton(onPressed: () => context.go(RouteNames.notificationPermission),
                    child: Text('Not now', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary))),
                const SizedBox(height: AppSpacing.lg32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
