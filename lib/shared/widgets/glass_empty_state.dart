import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';
import 'app_button.dart';

class GlassEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const GlassEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.xl40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonPink.withValues(alpha: 0.2),
                    AppColors.neonPurple.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.textPrimary,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scaleXY(end: 1.05, duration: 2.seconds)
                .shimmer(duration: 3.seconds, color: Colors.white24),
            const SizedBox(height: AppSpacing.lg32),
            Text(
              title,
              style: AppTextStyles.titleL,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm12),
            Text(
              message,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.lg32),
              AppButton(
                label: buttonText!,
                onTap: onButtonPressed!,
              ).animate().slideY(begin: 0.5, duration: 400.ms).fadeIn(),
            ]
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95);
  }
}
