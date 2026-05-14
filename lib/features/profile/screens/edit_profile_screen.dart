import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/route_names.dart';

import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/glass_text_field.dart';
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
  bool _isSaving = false;
  bool _isLocating = false;

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
                        child: GlassCard(
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(12),
                          opacity: 0.1,
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                        ),
                      ),
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
                          GlassTextField(
                            label: 'Name',
                            hintText: 'Your full name',
                            controller: _nameCtrl,
                          ),
                          const SizedBox(height: AppSpacing.md16),
                          GlassTextField(
                            label: 'Username',
                            hintText: '@username',
                            controller: _usernameCtrl,
                          ),
                          const SizedBox(height: AppSpacing.md16),
                          GlassTextField(
                            label: 'Bio',
                            hintText: 'Tell the world about yourself...',
                            controller: _bioCtrl,
                            maxLines: 3,
                          ),
                          const SizedBox(height: AppSpacing.md16),
                          GlassTextField(
                            label: 'Location',
                            hintText: 'Where are you based?',
                            controller: _locationCtrl,
                            prefixIcon: Icons.location_on_outlined,
                            suffixIcon: _isLocating 
                                ? Icons.hourglass_empty_rounded 
                                : Icons.my_location_rounded,
                            onSuffixTap: () async {
                              setState(() => _isLocating = true);
                              try {
                                final pos = await Geolocator.getCurrentPosition();
                                final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
                                if (places.isNotEmpty) {
                                  final p = places.first;
                                  _locationCtrl.text = "${p.locality}, ${p.country}";
                                }
                              } catch (_) {}
                              setState(() => _isLocating = false);
                            },
                          ),
                          const SizedBox(height: AppSpacing.md16),
                          GlassTextField(
                            label: 'Website',
                            hintText: 'https://yourwebsite.com',
                            controller: _websiteCtrl,
                            prefixIcon: Icons.link_rounded,
                            keyboardType: TextInputType.url,
                          ),
                          const SizedBox(height: AppSpacing.lg32),
                          AppButton(
                              label: 'Save Changes',
                              isLoading: _isSaving,
                              onTap: () async {
                                setState(() => _isSaving = true);
                                final err = await ref
                                    .read(settingsNotifierProvider.notifier)
                                    .updateProfile({
                                  'name': _nameCtrl.text,
                                  'username': _usernameCtrl.text,
                                  'bio': _bioCtrl.text,
                                  'location': _locationCtrl.text,
                                  'website': _websiteCtrl.text,
                                });
                                setState(() => _isSaving = false);
                                if (context.mounted) {
                                  if (err == null) {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go(RouteNames.profile);
                                    }
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
}
