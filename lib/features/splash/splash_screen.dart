import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/route_names.dart';

/// NicheSphere — Splash Screen (Screen 1)
/// Full screen gradient background (peach → lavender)
/// Animated logo, floating particle orbs, auto-navigate after 3s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: AppConstants.splashDurationMs),
      () {
        if (mounted) {
          context.go(RouteNames.welcome);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.bgSecondary,
                  AppColors.gradMid,
                  AppColors.gradEnd,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Floating particle orbs
          ...List.generate(6, (i) {
            final random = Random(i);
            final orbSize = 40.0 + random.nextDouble() * 60;
            final colors = [
              AppColors.bubblePink,
              AppColors.bubbleBlue,
              AppColors.bubbleGreen,
              AppColors.bubblePurple,
              AppColors.bubbleMint,
              AppColors.bubblePeach,
            ];
            return Positioned(
              left: random.nextDouble() * size.width,
              top: random.nextDouble() * size.height,
              child: Container(
                width: orbSize,
                height: orbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i % colors.length].withValues(alpha: 0.4),
                  boxShadow: [
                    BoxShadow(
                      color: colors[i % colors.length].withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              )
                  .animate(
                    onPlay: (c) => c.repeat(reverse: true),
                  )
                  .moveY(
                    begin: 0,
                    end: -20.0 - random.nextDouble() * 30,
                    duration: Duration(milliseconds: 3000 + random.nextInt(2000)),
                    curve: Curves.easeInOut,
                  )
                  .moveX(
                    begin: 0,
                    end: -10.0 + random.nextDouble() * 20,
                    duration: Duration(milliseconds: 4000 + random.nextInt(2000)),
                    curve: Curves.easeInOut,
                  ),
            );
          }),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo icon — animated cherry blossom style
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.neonPink, AppColors.neonPurple],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonPink.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.blur_on_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 32),

                // App name
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.displayXL.copyWith(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [AppColors.neonPink, AppColors.neonPurple],
                      ).createShader(const Rect.fromLTWH(0, 0, 250, 50)),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  AppConstants.appTagline,
                  style: AppTextStyles.bodyL.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
