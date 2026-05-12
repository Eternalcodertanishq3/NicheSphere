import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../providers/event_details_provider.dart';

/// NicheSphere — Event Details Screen (Screen 9)
/// Wired to real Firestore data via Riverpod providers.
class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(eventId));
    final isRsvped = ref.watch(isRsvpedProvider(eventId));
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: eventAsync.when(
        data: (event) {
          final neon = AppColors.neonForCategory(event.category);
          final rsvped = isRsvped.value ?? false;

          return Stack(children: [
            CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Stack(children: [
                SizedBox(
                  height: screenHeight * 0.45,
                  width: double.infinity,
                  child: CachedNetworkImage(imageUrl: event.imageUrl, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.gradEnd),
                    errorWidget: (_, __, ___) => Container(color: AppColors.gradEnd)),
                ),
                Positioned(top: 0, left: 0, right: 0,
                  child: Container(height: 120, decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent])))),
                Positioned(top: MediaQuery.of(context).viewPadding.top + 8, left: 16,
                  child: _glassCircle(Icons.arrow_back_rounded, () => context.pop())),
                Positioned(top: MediaQuery.of(context).viewPadding.top + 8, right: 16,
                  child: _glassCircle(Icons.share_rounded, () {})),
              ])),
              SliverToBoxAdapter(
                child: Transform.translate(offset: const Offset(0, -40),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: neon.withValues(alpha: 0.15), borderRadius: AppBorderRadius.pill),
                          child: Text(event.category, style: AppTextStyles.label.copyWith(color: neon, fontWeight: FontWeight.w700)),
                        ).animate().fadeIn().slideX(begin: -0.1),
                        const SizedBox(height: AppSpacing.sm12),
                        Text(event.title, style: AppTextStyles.displayL).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 4),
                        Text('by ${event.organizerName}', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.lg24),
                        // Info pills
                        Row(children: [
                          _infoPill(Icons.calendar_today_outlined, DateFormat('MMM dd').format(event.startAt)),
                          const SizedBox(width: 8),
                          _infoPill(Icons.location_on_outlined, event.locationName),
                          const SizedBox(width: 8),
                          _infoPill(Icons.person_outline_rounded, event.organizerName, avatar: event.organizerAvatarUrl),
                        ]).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: AppSpacing.lg24),
                        Text('About', style: AppTextStyles.titleL),
                        const SizedBox(height: 8),
                        Text(event.description, style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary, height: 1.6)),
                        const SizedBox(height: AppSpacing.lg24),
                        // Attendees
                        Row(children: [
                          SizedBox(width: 80, height: 32,
                            child: Stack(children: List.generate(3, (i) =>
                              Positioned(left: i * 20.0, child: AvatarWidget(size: 32,
                                imageUrl: 'https://i.pravatar.cc/100?img=${i + 10}'))))),
                          const SizedBox(width: 8),
                          Text('${event.attendeeCount} attending', style: AppTextStyles.bodyS),
                          if (event.maxAttendees > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.2), borderRadius: AppBorderRadius.pill),
                              child: Text('${event.maxAttendees - event.attendeeCount} spots left',
                                style: AppTextStyles.micro.copyWith(color: AppColors.neonOrange, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ]).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: AppSpacing.lg24),
                        // Rating
                        Row(children: [
                          ...List.generate(5, (i) => Icon(
                            i < event.avgRating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                            color: AppColors.warning, size: 20)),
                          const SizedBox(width: 8),
                          Text('${event.avgRating}', style: AppTextStyles.titleM),
                          Text(' (${event.reviewCount} reviews)', style: AppTextStyles.bodyS),
                        ]).animate().fadeIn(delay: 400.ms),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
            // CTA button
            Positioned(left: 24, right: 24, bottom: 24 + MediaQuery.of(context).viewPadding.bottom,
              child: AppButton(
                label: rsvped ? 'Cancel RSVP' : 'Attend Event',
                icon: rsvped ? Icons.close_rounded : Icons.check_circle_outline_rounded,
                onTap: () async {
                  final notifier = ref.read(rsvpNotifierProvider.notifier);
                  if (rsvped) {
                    await notifier.cancel(eventId);
                  } else {
                    await notifier.rsvp(eventId);
                  }
                },
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0)),
          ]);
        },
        loading: () => const Center(child: LoadingShimmer()),
        error: (e, _) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('Event not found', style: AppTextStyles.titleM),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => context.pop(),
              child: Text('Go Back', style: AppTextStyles.label.copyWith(color: AppColors.neonPink)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _glassCircle(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap,
      child: ClipOval(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(width: 40, height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
          child: Icon(icon, color: Colors.white, size: 20)))));
  }

  Widget _infoPill(IconData icon, String text, {String? avatar}) {
    return Expanded(child: GlassCard(blur: 10, opacity: 0.15, borderRadius: AppBorderRadius.sm,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (avatar != null) AvatarWidget(imageUrl: avatar, size: 20)
        else Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: AppTextStyles.micro, overflow: TextOverflow.ellipsis, maxLines: 1)),
      ])));
  }
}
