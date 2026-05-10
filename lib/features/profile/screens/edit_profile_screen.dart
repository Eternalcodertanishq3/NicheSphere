import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/constants/mock_data.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Edit Profile Screen (Screen 18)
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(width: AppSpacing.sm12),
                Text('Edit Profile', style: AppTextStyles.titleXL),
              ]),
            ).animate().fadeIn(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                child: Column(children: [
                  // Avatar picker
                  Stack(alignment: Alignment.bottomRight, children: [
                    AvatarWidget(imageUrl: user.avatarUrl, size: 100),
                    Container(width: 32, height: 32,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple])),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16)),
                  ]),
                  const SizedBox(height: AppSpacing.lg24),
                  _field('Name', user.name),
                  const SizedBox(height: AppSpacing.sm12),
                  _field('Username', user.username),
                  const SizedBox(height: AppSpacing.sm12),
                  _field('Bio', user.bio ?? '', maxLines: 3),
                  const SizedBox(height: AppSpacing.sm12),
                  _field('Location', user.location ?? ''),
                  const SizedBox(height: AppSpacing.sm12),
                  _field('Website', user.website ?? ''),
                  const SizedBox(height: AppSpacing.lg24),
                  AppButton(label: 'Save Changes', onTap: () => context.pop()),
                  const SizedBox(height: AppSpacing.lg32),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _field(String label, String value, {int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      GlassCard(blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.md,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(maxLines: maxLines, style: AppTextStyles.bodyM,
          controller: TextEditingController(text: value),
          decoration: InputDecoration.collapsed(hintText: label, hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textHint)))),
    ]);
  }
}
