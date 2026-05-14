import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_border_radius.dart';

/// NicheSphere — Glassmorphism Card (Section 7.1)
/// Every glass surface in the app must use this widget.
///
/// Implementation:
/// 1. ClipRRect with borderRadius
/// 2. BackdropFilter blur sigmaX=blur, sigmaY=blur
/// 3. Container with color = Colors.white.withOpacity(opacity)
/// 4. Border: 1.5px solid Colors.white.withOpacity(borderOpacity)
/// 5. Optional: BoxShadow with glowColor.withOpacity(0.2) blurRadius=20
class GlassCard extends StatefulWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tintColor;
  final Color? glowColor;
  final double glowIntensity;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.15,
    this.borderOpacity = 0.3,
    this.borderRadius,
    this.padding,
    this.tintColor,
    this.glowColor,
    this.glowIntensity = 0.2,
    this.onTap,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppBorderRadius.lg;

    final blurValue = widget.blur;
    final content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: (widget.tintColor ?? Colors.white)
            .withValues(alpha: widget.opacity),
        borderRadius: radius,
        border: Border.all(
          color: Colors.white.withValues(alpha: widget.borderOpacity),
          width: 1.5,
        ),
        boxShadow: widget.glowColor != null
            ? [
                BoxShadow(
                  color: widget.glowColor!
                      .withValues(alpha: widget.glowIntensity),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: widget.child,
    );

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => _scaleController.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _scaleController.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _scaleController.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: blurValue > 0
              ? BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurValue,
                    sigmaY: blurValue,
                  ),
                  child: content,
                )
              : content,
        ),
      ),
    );
  }
}
