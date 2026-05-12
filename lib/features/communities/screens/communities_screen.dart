import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../providers/communities_provider.dart';

/// NicheSphere — Communities Screen (Screen 11)
class CommunitiesScreen extends ConsumerStatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  ConsumerState<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends ConsumerState<CommunitiesScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final communitiesAsync = _tabIndex == 0
        ? ref.watch(userCommunitiesProvider)
        : ref.watch(communitiesListProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                GestureDetector(onTap: () => context.go(RouteNames.home), child: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(width: AppSpacing.sm12),
                Text('Spheres', style: AppTextStyles.displayL),
              ]),
            ).animate().fadeIn(),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: Row(children: ['My Spheres', 'Discover', 'Trending'].asMap().entries.map((e) =>
                GestureDetector(
                  onTap: () => setState(() => _tabIndex = e.key),
                  child: Padding(padding: const EdgeInsets.only(right: 16),
                    child: Text(e.value, style: AppTextStyles.titleM.copyWith(
                      color: _tabIndex == e.key ? AppColors.neonPink : AppColors.textHint))),
                )).toList()),
            ),
            const SizedBox(height: AppSpacing.md16),
            Expanded(
              child: communitiesAsync.when(
                data: (communities) {
                  if (communities.isEmpty) {
                    return Center(child: Text(_tabIndex == 0 ? 'You haven\'t joined any spheres yet' : 'No communities found'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                    itemCount: communities.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final c = communities[i];
                      final neon = AppColors.neonForCategory(c.category);
                      final isMember = _tabIndex == 0; // Or check real status if needed
                      return GlassCard(blur: 15, opacity: 0.2, borderRadius: AppBorderRadius.lg,
                        padding: const EdgeInsets.all(AppSpacing.sm12),
                        child: Row(children: [
                          ClipRRect(borderRadius: AppBorderRadius.sm,
                            child: CachedNetworkImage(imageUrl: c.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                              placeholder: (_, __) => Container(width: 60, height: 60, color: AppColors.gradEnd.withValues(alpha: 0.3)),
                              errorWidget: (_, __, ___) => Container(width: 60, height: 60, color: AppColors.gradEnd))),
                          const SizedBox(width: AppSpacing.sm12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c.name, style: AppTextStyles.titleM),
                            const SizedBox(height: 2),
                            Text(c.description, style: AppTextStyles.bodyS, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('${c.memberCount} members', style: AppTextStyles.micro),
                            ]),
                          ])),
                          GestureDetector(
                            onTap: () async {
                              final notifier = ref.read(communityActionProvider.notifier);
                              if (isMember) {
                                await notifier.leave(c.id);
                              } else {
                                await notifier.join(c.id);
                              }
                              if (context.mounted && _tabIndex == 0) {
                                ref.invalidate(userCommunitiesProvider);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: isMember ? Colors.transparent : neon.withValues(alpha: 0.15),
                                borderRadius: AppBorderRadius.pill,
                                border: Border.all(color: neon.withValues(alpha: 0.5))),
                              child: Text(isMember ? 'Leave' : 'Join', style: AppTextStyles.label.copyWith(
                                color: neon, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ]),
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 300.ms).slideX(begin: 0.05, end: 0);
                    },
                  );
                },
                loading: () => const LoadingShimmer(),
                error: (e, _) => const Center(child: Text('Failed to load communities')),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
