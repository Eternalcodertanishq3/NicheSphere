import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// NicheSphere — Gradient Background (Section 1.4)
/// Every scaffold background must use this widget.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgSecondary, // warm peach
            Colors.white,
            AppColors.gradEnd, // soft lavender
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
