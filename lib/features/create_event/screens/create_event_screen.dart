import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Create Event Screen (Screen 10)
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _step = 0;
  int _selectedCat = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                GestureDetector(onTap: () => _step > 0 ? setState(() => _step--) : context.go(RouteNames.home),
                  child: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(width: AppSpacing.sm12),
                Text('Create Event', style: AppTextStyles.titleXL),
                const Spacer(),
                Text('${_step + 1}/3', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
              ]),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: Row(children: List.generate(3, (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4, margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.neonPink : AppColors.bubblePink,
                    borderRadius: AppBorderRadius.pill),
                )))),
            ),
            const SizedBox(height: AppSpacing.lg24),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: [_stepBasics(), _stepDetails(), _stepCommunity()][_step],
            )),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: AppButton(
                label: _step < 2 ? 'Next' : 'Publish Event',
                icon: _step < 2 ? Icons.arrow_forward_rounded : Icons.celebration_rounded,
                onTap: () {
                  if (_step < 2) { setState(() => _step++); }
                  else { context.go(RouteNames.home); }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _stepBasics() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Event Basics', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      _glassField('Event Name', Icons.event_rounded),
      const SizedBox(height: AppSpacing.md16),
      _glassField('Description', Icons.description_outlined, maxLines: 4),
      const SizedBox(height: AppSpacing.md20),
      Text('Category', style: AppTextStyles.titleM),
      const SizedBox(height: AppSpacing.sm12),
      SizedBox(height: 44, child: ListView.separated(
        scrollDirection: Axis.horizontal, itemCount: AppConstants.categories.length - 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = AppConstants.categories[i + 1];
          final isActive = _selectedCat == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = i),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.neonPink.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.5),
                borderRadius: AppBorderRadius.pill,
                border: Border.all(color: isActive ? AppColors.neonPink : Colors.white.withValues(alpha: 0.4))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(cat['emoji']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(cat['name']!, style: AppTextStyles.label.copyWith(color: isActive ? AppColors.neonPink : AppColors.textSecondary)),
              ])));
        },
      )),
    ]);
  }

  Widget _stepDetails() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Event Details', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      // Image picker placeholder
      GlassCard(blur: 10, opacity: 0.15, borderRadius: AppBorderRadius.xl,
        padding: const EdgeInsets.all(AppSpacing.xl40),
        child: Column(children: [
          const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.textHint),
          const SizedBox(height: 8),
          Text('Add Cover Image', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
        ])),
      const SizedBox(height: AppSpacing.md20),
      _glassField('Date & Time', Icons.calendar_today_outlined),
      const SizedBox(height: AppSpacing.md16),
      _glassField('Duration', Icons.timer_outlined),
      const SizedBox(height: AppSpacing.md16),
      _glassField('Location', Icons.location_on_outlined),
      const SizedBox(height: AppSpacing.md16),
      Row(children: [
        Expanded(child: _glassField('Max Attendees', Icons.people_outline_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _glassField('Price', Icons.attach_money_rounded)),
      ]),
    ]);
  }

  Widget _stepCommunity() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Community & Tags', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      _glassField('Link to a Sphere', Icons.hub_outlined),
      const SizedBox(height: AppSpacing.md16),
      _glassField('Tags (comma separated)', Icons.tag_rounded),
      const SizedBox(height: AppSpacing.md20),
      Text('Visibility', style: AppTextStyles.titleM),
      const SizedBox(height: AppSpacing.sm12),
      Row(children: ['Public', 'Friends Only', 'Private'].map((v) => Expanded(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GlassCard(blur: 10, opacity: v == 'Public' ? 0.3 : 0.15, borderRadius: AppBorderRadius.sm,
            glowColor: v == 'Public' ? AppColors.neonPink : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(child: Text(v, style: AppTextStyles.label.copyWith(
              color: v == 'Public' ? AppColors.neonPink : AppColors.textSecondary))))))).toList()),
    ]);
  }

  Widget _glassField(String hint, IconData icon, {int maxLines = 1}) {
    return GlassCard(blur: 10, opacity: 0.2, borderRadius: AppBorderRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(maxLines: maxLines, style: AppTextStyles.bodyM,
        decoration: InputDecoration.collapsed(hintText: hint, hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textHint))));
  }
}
