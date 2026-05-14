import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'glass_card.dart';

/// NicheSphere — Standard Premium Back Button
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;

  const AppBackButton({
    super.key,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(12),
        opacity: 0.1,
        child: Icon(
          Icons.arrow_back_rounded,
          color: iconColor ?? AppColors.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}
