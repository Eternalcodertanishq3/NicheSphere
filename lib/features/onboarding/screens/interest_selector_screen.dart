import 'dart:math';
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
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Interest Selector Screen (Screen 3)
/// Scattered floating bubble layout with neon glow selection.
/// This is the MOST CRITICAL UI screen per the master prompt.
class InterestSelectorScreen extends StatefulWidget {
  const InterestSelectorScreen({super.key});

  @override
  State<InterestSelectorScreen> createState() => _InterestSelectorScreenState();
}

class _InterestSelectorScreenState extends State<InterestSelectorScreen> {
  final Set<String> _selected = {};

  Color _neonForGroup(String group) {
    switch (group) {
      case 'blue':
        return AppColors.neonBlue;
      case 'pink':
        return AppColors.neonPink;
      case 'green':
        return AppColors.neonGreen;
      case 'purple':
        return AppColors.neonPurple;
      case 'orange':
        return AppColors.neonOrange;
      default:
        return AppColors.neonBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final interests = AppConstants.interests;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF1E6),
              Color(0xFFFFE0CC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg24),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg32),
                child: Column(
                  children: [
                    Text(
                      'What are you into?',
                      style: AppTextStyles.displayL,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSpacing.xs8),
                    Text(
                      'Pick at least 3 to personalize your feed',
                      style: AppTextStyles.bodyL.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg24),

              // Scattered bubble layout
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md16,
                  ),
                  child: _buildScatteredBubbles(interests, screenWidth),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg24),
                child: AppButton(
                  label: _selected.length < AppConstants.minInterests
                      ? 'Select ${AppConstants.minInterests - _selected.length} more'
                      : 'Continue',
                  isDisabled: _selected.length < AppConstants.minInterests,
                  onTap: () => context.go(RouteNames.locationPermission),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9A76), Color(0xFFFF6CB0)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScatteredBubbles(
    List<Map<String, String>> interests,
    double screenWidth,
  ) {
    // Use Wrap for organic scattered look with varying sizes
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xs8,
      runSpacing: AppSpacing.xs8,
      children: List.generate(interests.length, (i) {
        final interest = interests[i];
        final name = interest['name']!;
        final emoji = interest['emoji']!;
        final neonGroup = interest['neon']!;
        final isSelected = _selected.contains(name);
        final neonColor = _neonForGroup(neonGroup);
        final pastelColor = AppColors.bubbleForIndex(i);

        // Random-ish rotation for scattered look
        final rotation = (sin(i * 0.9) * 4).clamp(-8.0, 8.0);
        // Vary sizes — some "featured" interests are larger
        final isFeatured = i % 5 == 0;
        final fontSize = isFeatured ? 15.0 : 13.0;
        final vertPadding = isFeatured ? 12.0 : 8.0;
        final horizPadding = isFeatured ? 20.0 : 14.0;

        return Transform.rotate(
          angle: rotation * pi / 180,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selected.remove(name);
                } else {
                  _selected.add(name);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: horizPadding,
                vertical: vertPadding,
              ),
              transform: isSelected
                  ? Matrix4.diagonal3Values(1.08, 1.08, 1.0)
                  : Matrix4.identity(),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? neonColor.withOpacity(0.18)
                    : pastelColor.withOpacity(0.7),
                borderRadius: AppBorderRadius.pill,
                border: Border.all(
                  color: isSelected
                      ? neonColor.withOpacity(0.8)
                      : Colors.white.withOpacity(0.6),
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: neonColor.withOpacity(0.35),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: TextStyle(fontSize: fontSize + 2)),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: AppTextStyles.label.copyWith(
                      fontSize: fontSize,
                      color: isSelected ? neonColor : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 20 * i),
              duration: 300.ms,
            )
            .slideX(
              begin: (i % 2 == 0) ? -0.2 : 0.2,
              end: 0,
              delay: Duration(milliseconds: 20 * i),
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            );
      }),
    );
  }
}
