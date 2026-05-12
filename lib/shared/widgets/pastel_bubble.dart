import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_spacing.dart';

/// NicheSphere — Pastel Bubble Widget (Section 7.3)
/// Used for interest tags, category chips, etc.
class PastelBubble extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final VoidCallback? onTap;
  final double? fontSize;

  const PastelBubble({
    super.key,
    required this.label,
    this.emoji,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
    this.onTap,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final neonColor = selectedColor ?? AppColors.neonPink;
    final pastelColor = unselectedColor ?? AppColors.bubblePink;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md16,
          vertical: AppSpacing.xs8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? neonColor.withValues(alpha: 0.18)
              : pastelColor.withValues(alpha: 0.6),
          borderRadius: AppBorderRadius.pill,
          border: Border.all(
            color: isSelected
                ? neonColor.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: neonColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        transform: isSelected
            ? Matrix4.diagonal3Values(1.08, 1.08, 1.0)
            : Matrix4.identity(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: fontSize ?? 14)),
              const SizedBox(width: AppSpacing.xs4),
            ],
            Text(
              label,
              style: (fontSize != null
                      ? AppTextStyles.label.copyWith(fontSize: fontSize)
                      : AppTextStyles.label)
                  .copyWith(
                color: isSelected ? neonColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
