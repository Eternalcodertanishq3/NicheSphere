import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';

import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../profile/providers/profile_provider.dart';
import '../../settings/providers/settings_provider.dart';

/// NicheSphere — Edit Profile Screen (Screen 18)
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Sign in first'));
              }
              if (!_initialized) {
                _nameCtrl.text = user.name;
                _usernameCtrl.text = user.username;
                _bioCtrl.text = user.bio ?? '';
                _locationCtrl.text = user.location ?? '';
                _websiteCtrl.text = user.website ?? '';
                _initialized = true;
              }
              return Column(children: [
                Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg24),
                    child: Row(children: [
                      GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.arrow_back_rounded)),
                      const SizedBox(width: AppSpacing.sm12),
                      Text('Edit Profile', style: AppTextStyles.titleXL),
                    ])).animate().fadeIn(),
                Expanded(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg24),
                        child: Column(children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            AvatarWidget(imageUrl: user.avatarUrl, size: 100),
                            Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: [
                                      AppColors.neonPink,
                                      AppColors.neonPurple
                                    ])),
                                child: const Icon(Icons.camera_alt_rounded,
                                    color: Colors.white, size: 16)),
                          ]),
                          const SizedBox(height: AppSpacing.lg24),
                          _field('Name', _nameCtrl),
                          const SizedBox(height: AppSpacing.sm12),
                          _field('Username', _usernameCtrl),
                          const SizedBox(height: AppSpacing.sm12),
                          _field('Bio', _bioCtrl, maxLines: 3),
                          const SizedBox(height: AppSpacing.sm12),
                          _field('Location', _locationCtrl),
                          const SizedBox(height: AppSpacing.sm12),
                          _field('Website', _websiteCtrl),
                          const SizedBox(height: AppSpacing.lg24),
                          AppButton(
                              label: 'Save Changes',
                              onTap: () async {
                                final err = await ref
                                    .read(settingsNotifierProvider.notifier)
                                    .updateProfile({
                                  'name': _nameCtrl.text,
                                  'username': _usernameCtrl.text,
                                  'bio': _bioCtrl.text,
                                  'location': _locationCtrl.text,
                                  'website': _websiteCtrl.text,
                                });
                                if (context.mounted) {
                                  if (err == null) {
                                    context.pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(err)));
                                  }
                                }
                              }),
                          const SizedBox(height: AppSpacing.lg32),
                        ]))),
              ]);
            },
            loading: () => const LoadingShimmer(),
            error: (_, __) =>
                const Center(child: Text('Error loading profile')),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      GlassCard(
          blur: 10,
          opacity: 0.2,
          borderRadius: AppBorderRadius.md,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
              maxLines: maxLines,
              style: AppTextStyles.bodyM,
              controller: ctrl,
              decoration: InputDecoration.collapsed(
                  hintText: label,
                  hintStyle: AppTextStyles.bodyM
                      .copyWith(color: AppColors.textHint)))),
    ]);
  }
}
