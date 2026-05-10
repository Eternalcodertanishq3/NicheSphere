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

/// NicheSphere — Settings Screen (Screen 20)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(width: AppSpacing.sm12),
                Text('Settings', style: AppTextStyles.displayL),
              ]),
            ).animate().fadeIn(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                children: [
                  _sectionTitle('Account'),
                  _tile(Icons.person_outline_rounded, 'Edit Profile', AppColors.neonPink, () => context.go(RouteNames.editProfile)),
                  _tile(Icons.lock_outline_rounded, 'Change Password', AppColors.neonPurple, () {}),
                  _tile(Icons.link_rounded, 'Connected Accounts', AppColors.neonBlue, () {}),
                  const SizedBox(height: AppSpacing.md20),
                  _sectionTitle('Preferences'),
                  _tile(Icons.notifications_outlined, 'Notifications', AppColors.neonOrange, () {}),
                  _tile(Icons.shield_outlined, 'Privacy', AppColors.neonGreen, () {}),
                  _tile(Icons.location_on_outlined, 'Location Sharing', AppColors.neonBlue, () {}),
                  const SizedBox(height: AppSpacing.md20),
                  _sectionTitle('App'),
                  _tile(Icons.palette_outlined, 'Theme', AppColors.neonPurple, () {}),
                  _tile(Icons.language_rounded, 'Language', AppColors.neonBlue, () {}),
                  _tile(Icons.delete_sweep_outlined, 'Clear Cache', AppColors.neonOrange, () {}),
                  const SizedBox(height: AppSpacing.md20),
                  _sectionTitle('Support'),
                  _tile(Icons.help_outline_rounded, 'Help Center', AppColors.neonGreen, () {}),
                  _tile(Icons.bug_report_outlined, 'Report a Bug', AppColors.neonOrange, () {}),
                  _tile(Icons.star_outline_rounded, 'Rate the App', AppColors.neonPink, () {}),
                  const SizedBox(height: AppSpacing.md20),
                  _sectionTitle('Danger Zone'),
                  _tile(Icons.delete_forever_outlined, 'Delete Account', AppColors.error, () {}),
                  const SizedBox(height: AppSpacing.xl48),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
  );

  Widget _tile(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(blur: 10, opacity: 0.15, borderRadius: AppBorderRadius.sm,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: AppBorderRadius.xs),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: AppSpacing.sm12),
          Expanded(child: Text(label, style: AppTextStyles.bodyM)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
        ])),
    );
  }
}
