import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_border_radius.dart';

/// NicheSphere — Loading Shimmer (Section 7.5)
/// Pastel shimmer: base=Color(0xFFE8E4FF), highlight=Colors.white
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius,
  });

  /// Card shimmer placeholder
  factory LoadingShimmer.card() {
    return const LoadingShimmer(
      width: 280,
      height: 380,
      borderRadius: BorderRadius.all(Radius.circular(24)),
    );
  }

  /// List tile shimmer placeholder
  factory LoadingShimmer.listTile() {
    return const LoadingShimmer(
      height: 80,
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );
  }

  /// Circle shimmer (avatar)
  factory LoadingShimmer.circle({double size = 48}) {
    return LoadingShimmer(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gradEnd.withOpacity(0.4),
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? AppBorderRadius.lg,
        ),
      ),
    );
  }
}

/// Shimmer wrapper for multiple cards in a horizontal list
class ShimmerCardList extends StatelessWidget {
  final int count;
  final double cardWidth;
  final double cardHeight;

  const ShimmerCardList({
    super.key,
    this.count = 3,
    this.cardWidth = 280,
    this.cardHeight = 380,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => LoadingShimmer(
          width: cardWidth,
          height: cardHeight,
          borderRadius: AppBorderRadius.xl,
        ),
      ),
    );
  }
}
