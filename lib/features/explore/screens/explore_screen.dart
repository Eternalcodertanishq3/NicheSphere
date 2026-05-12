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
import '../providers/explore_provider.dart';

/// NicheSphere — Explore Screen (Screen 8)
/// Wired to real Firestore data via Riverpod providers.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ['All', 'Today', 'This Week', 'Free', 'Online'];
    final eventsAsync = ref.watch(allEventsProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  GestureDetector(onTap: () => context.go(RouteNames.home),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary)),
                  const SizedBox(width: AppSpacing.sm12),
                  Expanded(child: GlassCard(blur: 15, opacity: 0.25, borderRadius: AppBorderRadius.pill,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(children: [
                      const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(
                        style: AppTextStyles.bodyM,
                        onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
                        decoration: InputDecoration.collapsed(hintText: 'Search events...', hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textHint)),
                      )),
                    ]))),
                ]).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: AppSpacing.sm12),
                SizedBox(height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal, itemCount: filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => GlassCard(blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.pill,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(filters[i], style: AppTextStyles.label.copyWith(color: i == 0 ? AppColors.neonPink : AppColors.textSecondary))),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const Center(child: Text('No events found'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75),
                    itemCount: events.length,
                    itemBuilder: (_, i) {
                      final e = events[i];
                      return GestureDetector(
                        onTap: () => context.go('/event/${e.id}'),
                        child: ClipRRect(borderRadius: AppBorderRadius.lg,
                          child: Stack(children: [
                            Positioned.fill(child: CachedNetworkImage(imageUrl: e.imageUrl, fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: AppColors.gradEnd.withValues(alpha: 0.3)),
                              errorWidget: (_, __, ___) => Container(color: AppColors.gradEnd))),
                            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)], stops: const [0.3, 1.0])))),
                            Positioned(left: 8, right: 8, bottom: 8,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                Text(e.title, style: AppTextStyles.label.copyWith(color: Colors.white, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('${e.attendeeCount} going', style: AppTextStyles.micro.copyWith(color: Colors.white70)),
                              ])),
                          ])),
                      ).animate().fadeIn(delay: Duration(milliseconds: 50 * i), duration: 300.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
                    },
                  );
                },
                loading: () => const LoadingShimmer(),
                error: (e, _) => Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('Something went wrong', style: AppTextStyles.bodyM),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => ref.invalidate(allEventsProvider),
                      child: Text('Retry', style: AppTextStyles.label.copyWith(color: AppColors.neonPink)),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
