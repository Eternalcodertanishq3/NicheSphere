import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../data/models/event_model.dart';
import 'package:intl/intl.dart';

/// NicheSphere — Home Screen "Discover" (Screen 7)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  int _selectedCategory = 0;

  void _onNavTap(int i) {
    setState(() => _navIndex = i);
    switch (i) {
      case 1: context.go(RouteNames.explore); break;
      case 2: context.go(RouteNames.createEvent); break;
      case 3: context.go(RouteNames.inbox); break;
      case 4: context.go(RouteNames.profile); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildCategoryChips()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Featured Events', 'See All')),
                  SliverToBoxAdapter(child: _buildFeaturedCarousel()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Popular Spheres', 'See All')),
                  SliverToBoxAdapter(child: _buildPopularSpheres()),
                  SliverToBoxAdapter(child: _buildSectionHeader('Upcoming Near You', 'See All')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _buildUpcomingTile(MockData.upcomingEvents[i], i),
                      childCount: MockData.upcomingEvents.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ),
          AppBottomNav(currentIndex: _navIndex, onTap: _onNavTap),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg24, AppSpacing.md16, AppSpacing.lg24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.neonPink, AppColors.neonPurple],
                ).createShader(bounds),
                child: Text('Discover', style: AppTextStyles.displayL.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('San Francisco, CA', style: AppTextStyles.bodyS),
              ]),
            ]),
          ),
          GestureDetector(
            onTap: () => context.go(RouteNames.profile),
            child: const AvatarWidget(imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100', size: 44),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg24, AppSpacing.md16, AppSpacing.lg24, 0),
      child: GlassCard(
        blur: 15, opacity: 0.25, borderRadius: AppBorderRadius.pill,
        onTap: () => context.go(RouteNames.explore),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md16, vertical: AppSpacing.sm12),
        child: Row(children: [
          Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
          const SizedBox(width: AppSpacing.xs8),
          Text('Search events, communities...', style: AppTextStyles.bodyM.copyWith(color: AppColors.textHint)),
          const Spacer(),
          Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
        ]),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildCategoryChips() {
    final cats = AppConstants.categories;
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg24, AppSpacing.sm12, AppSpacing.lg24, 0),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs8),
        itemBuilder: (_, i) {
          final isActive = _selectedCategory == i;
          final cat = cats[i];
          final neonColor = AppColors.neonForCategory(cat['name']!);
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? neonColor.withOpacity(0.18) : Colors.white.withOpacity(0.5),
                borderRadius: AppBorderRadius.pill,
                border: Border.all(color: isActive ? neonColor.withOpacity(0.6) : Colors.white.withOpacity(0.4), width: 1.5),
                boxShadow: isActive ? [BoxShadow(color: neonColor.withOpacity(0.25), blurRadius: 12)] : null,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(cat['emoji']!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(cat['name']!, style: AppTextStyles.label.copyWith(
                  color: isActive ? neonColor : AppColors.textSecondary, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
              ]),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 50 * i), duration: 300.ms);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg24, AppSpacing.lg24, AppSpacing.lg24, AppSpacing.sm12),
      child: Row(children: [
        Text(title, style: AppTextStyles.titleL),
        const Spacer(),
        Text(action, style: AppTextStyles.label.copyWith(color: AppColors.neonPink)),
      ]),
    );
  }

  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: 380,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
        itemCount: MockData.featuredEvents.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md16),
        itemBuilder: (_, i) => _buildFeaturedCard(MockData.featuredEvents[i], i),
      ),
    );
  }

  Widget _buildFeaturedCard(EventModel event, int index) {
    final neon = AppColors.neonForCategory(event.category);
    return GestureDetector(
      onTap: () => context.go('/event/${event.id}'),
      child: SizedBox(
        width: 280,
        child: ClipRRect(
          borderRadius: AppBorderRadius.xl,
          child: Stack(children: [
            Positioned.fill(
              child: CachedNetworkImage(imageUrl: event.imageUrl, fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.gradEnd.withOpacity(0.3)),
                errorWidget: (_, __, ___) => Container(color: AppColors.gradEnd, child: const Icon(Icons.image, size: 40, color: AppColors.textHint))),
            ),
            Positioned.fill(
              child: DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)], stops: const [0.4, 1.0]),
              )),
            ),
            // Category badge
            Positioned(top: 12, left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: neon.withOpacity(0.9), borderRadius: AppBorderRadius.xs),
                child: Text(event.category, style: AppTextStyles.micro.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            // Heart
            Positioned(top: 12, right: 12,
              child: ClipOval(
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                    child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
            // Bottom info
            Positioned(left: 0, right: 0, bottom: 0,
              child: ClipRRect(
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text(event.title, style: AppTextStyles.titleM.copyWith(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(child: Text(event.locationName, style: AppTextStyles.micro.copyWith(color: Colors.white70), overflow: TextOverflow.ellipsis)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(DateFormat('MMM dd, h:mm a').format(event.startAt), style: AppTextStyles.micro.copyWith(color: Colors.white70)),
                        const Spacer(),
                        const Icon(Icons.people_outline_rounded, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text('${event.attendeeCount}', style: AppTextStyles.micro.copyWith(color: Colors.white70)),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms)
     .slideX(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildPopularSpheres() {
    final emojis = ['💪', '🎮', '🎨', '💻', '🍳'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
        itemCount: MockData.communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs8),
        itemBuilder: (_, i) {
          final c = MockData.communities[i];
          return GlassCard(
            blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.pill,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onTap: () {},
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(emojis[i % emojis.length], style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(c.name, style: AppTextStyles.label),
              const SizedBox(width: 4),
              Text('${c.memberCount}', style: AppTextStyles.micro.copyWith(color: AppColors.textHint)),
            ]),
          ).animate().fadeIn(delay: Duration(milliseconds: 50 * i), duration: 300.ms);
        },
      ),
    );
  }

  Widget _buildUpcomingTile(EventModel event, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24, vertical: AppSpacing.xs4),
      child: GlassCard(
        blur: 15, opacity: 0.2, borderRadius: AppBorderRadius.lg,
        onTap: () => context.go('/event/${event.id}'),
        padding: const EdgeInsets.all(AppSpacing.sm12),
        child: Row(children: [
          ClipRRect(
            borderRadius: AppBorderRadius.sm,
            child: CachedNetworkImage(imageUrl: event.imageUrl, width: 72, height: 72, fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 72, height: 72, color: AppColors.gradEnd.withOpacity(0.3)),
              errorWidget: (_, __, ___) => Container(width: 72, height: 72, color: AppColors.gradEnd)),
          ),
          const SizedBox(width: AppSpacing.sm12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.title, style: AppTextStyles.titleM, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(DateFormat('MMM dd, h:mm a').format(event.startAt), style: AppTextStyles.bodyS),
            ]),
            const SizedBox(height: 2),
            Row(children: [
              Icon(Icons.people_outline_rounded, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${event.attendeeCount} going', style: AppTextStyles.bodyS),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple]),
                  borderRadius: AppBorderRadius.pill,
                ),
                child: Text('RSVP', style: AppTextStyles.micro.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ]),
          ])),
        ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms)
     .slideX(begin: 0.1, end: 0, duration: 300.ms);
  }
}
