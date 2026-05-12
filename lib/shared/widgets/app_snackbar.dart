import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// NicheSphere — Snackbar Utility
/// success (green), error (pink), info (blue)
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = switch (type) {
      SnackbarType.success => AppColors.success,
      SnackbarType.error => AppColors.error,
      SnackbarType.info => AppColors.info,
      SnackbarType.warning => AppColors.warning,
    };

    final icon = switch (type) {
      SnackbarType.success => Icons.check_circle_rounded,
      SnackbarType.error => Icons.error_rounded,
      SnackbarType.info => Icons.info_rounded,
      SnackbarType.warning => Icons.warning_rounded,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.md16,
          0,
          AppSpacing.md16,
          AppSpacing.xxl80 + AppSpacing.lg24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: color.withValues(alpha: 0.9),
        duration: duration,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.xs8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SnackbarType { success, error, info, warning }
