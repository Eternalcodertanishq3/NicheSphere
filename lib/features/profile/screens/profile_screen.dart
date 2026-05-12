import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../providers/profile_provider.dart';

/// NicheSphere — Profile Screen (Screen 17)
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return Scaffold(
      body: Stack(children: [
        GradientBackground(
          child: SafeArea(
            bottom: false,
            child: userAsync.when(
              data: (user) {
                if (user == null) return const Center(child: Text('Sign in to view profile'));
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(children: [
                    const SizedBox(height: AppSpacing.md16),
                    _header(context),
                    const SizedBox(height: AppSpacing.lg24),
                    _avatarSection(user),
                    const SizedBox(height: AppSpacing.lg24),
                    _statsRow(user),
                    const SizedBox(height: AppSpacing.lg24),
                    _interests(user),
                    const SizedBox(height: AppSpacing.lg24),
                    _badges(context),
                  ]),
                );
              },
              loading: () => const LoadingShimmer(),
              error: (_, __) => Center(child: GestureDetector(
                onTap: () => ref.invalidate(currentUserProvider),
                child: Text('Retry', style: AppTextStyles.label.copyWith(color: AppColors.neonPink)))),
            ),
          ),
        ),
        AppBottomNav(currentIndex: 4, onTap: (i) {
          switch (i) {
            case 0: context.go(RouteNames.home);
            case 1: context.go(RouteNames.explore);
            case 2: context.go(RouteNames.createEvent);
            case 3: context.go(RouteNames.inbox);
          }
        }),
      ]),
    );
  }

  Widget _header(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
    child: Row(children: [
      GestureDetector(onTap: () => context.go(RouteNames.home), child: const Icon(Icons.arrow_back_rounded)),
      const Spacer(),
      GlassCard(blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.pill,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: () => context.go(RouteNames.editProfile),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.edit_rounded, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text('Edit', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
        ])),
      const SizedBox(width: 8),
      GestureDetector(onTap: () => context.go(RouteNames.settings),
        child: const Icon(Icons.settings_outlined, color: AppColors.textSecondary)),
    ]),
  ).animate().fadeIn();

  Widget _avatarSection(dynamic user) => Column(children: [
    AvatarWidget(imageUrl: user.avatarUrl, size: 100, borderColor: AppColors.neonPink.withValues(alpha: 0.5)),
    const SizedBox(height: AppSpacing.md16),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(user.name, style: AppTextStyles.titleXL),
      if (user.isVerified) ...[const SizedBox(width: 6), const Icon(Icons.verified_rounded, color: AppColors.neonBlue, size: 20)],
    ]),
    Text('@${user.username}', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
    if (user.bio != null) ...[const SizedBox(height: 8), Text(user.bio!, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center)],
    if (user.location != null) ...[const SizedBox(height: 8), Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: AppColors.bubblePeach, borderRadius: AppBorderRadius.pill),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.location_on_rounded, size: 14, color: AppColors.neonOrange), const SizedBox(width: 4),
        Text(user.location!, style: AppTextStyles.label.copyWith(color: AppColors.neonOrange)),
      ]))],
  ]).animate().fadeIn(delay: 100.ms);

  Widget _statsRow(dynamic user) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
    child: GlassCard(blur: 15, opacity: 0.2, borderRadius: AppBorderRadius.lg,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md16),
      child: Row(children: [
        _stat('${user.eventsHosted}', 'Hosted'), _div(),
        _stat('${user.eventsAttended}', 'Attended'), _div(),
        _stat('${user.followersCount}', 'Followers'), _div(),
        _stat('${user.followingCount}', 'Following'),
      ])),
  ).animate().fadeIn(delay: 200.ms);

  Widget _interests(dynamic user) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Interests', style: AppTextStyles.titleL), const SizedBox(height: AppSpacing.sm12),
      Wrap(spacing: 8, runSpacing: 8, children: (user.interests as List<String>).map((i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: AppColors.neonForCategory(i).withValues(alpha: 0.15), borderRadius: AppBorderRadius.pill,
          border: Border.all(color: AppColors.neonForCategory(i).withValues(alpha: 0.4))),
        child: Text(i, style: AppTextStyles.label.copyWith(color: AppColors.neonForCategory(i))))).toList()),
    ]),
  ).animate().fadeIn(delay: 300.ms);

  Widget _badges(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text('Badges', style: AppTextStyles.titleL), const Spacer(),
        GestureDetector(onTap: () => context.go(RouteNames.badges),
          child: Text('View All', style: AppTextStyles.label.copyWith(color: AppColors.neonPink)))]),
      const SizedBox(height: AppSpacing.sm12),
      SizedBox(height: 90, child: ListView(scrollDirection: Axis.horizontal, children: [
        _badge('🌟', 'Explorer', AppColors.neonOrange), _badge('🎤', 'Host', AppColors.neonPink), _badge('🏗️', 'Builder', AppColors.neonBlue),
      ])),
    ]),
  ).animate().fadeIn(delay: 400.ms);

  Widget _stat(String v, String l) => Expanded(child: Column(children: [
    Text(v, style: AppTextStyles.titleL.copyWith(color: AppColors.neonPink)), const SizedBox(height: 2), Text(l, style: AppTextStyles.micro)]));
  Widget _div() => Container(width: 1, height: 30, color: AppColors.textHint.withValues(alpha: 0.2));
  Widget _badge(String e, String n, Color c) => Padding(padding: const EdgeInsets.only(right: 12),
    child: GlassCard(blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.lg, glowColor: c, padding: const EdgeInsets.all(16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(e, style: const TextStyle(fontSize: 28)), const SizedBox(height: 4), Text(n, style: AppTextStyles.label.copyWith(color: c))])));
}
