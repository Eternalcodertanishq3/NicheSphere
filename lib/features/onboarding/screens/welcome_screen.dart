import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Welcome Screen (Onboarding Step 1 / Screen 2)
/// 3 slides with PageView, dot indicators, Get Started button.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _slides = const [
    _OnboardingSlide(
      icon: Icons.people_rounded,
      title: 'Discover Nearby People',
      subtitle: 'Discover nearby people who share your passions',
      color: AppColors.neonPink,
    ),
    _OnboardingSlide(
      icon: Icons.event_rounded,
      title: 'Join Micro-Events',
      subtitle: 'Join micro-events crafted for your interests',
      color: AppColors.neonPurple,
    ),
    _OnboardingSlide(
      icon: Icons.hub_rounded,
      title: 'Build Communities',
      subtitle: 'Build your local micro-community',
      color: AppColors.neonBlue,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button top right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md16),
                  child: TextButton(
                    onPressed: () => context.go(RouteNames.interestSelector),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView slides
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustration circle
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  slide.color.withOpacity(0.2),
                                  slide.color.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: slide.color.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              slide.icon,
                              size: 80,
                              color: slide.color,
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                duration: 500.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .fadeIn(duration: 500.ms),

                          const SizedBox(height: AppSpacing.xl48),

                          Text(
                            slide.title,
                            style: AppTextStyles.displayL,
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),

                          const SizedBox(height: AppSpacing.sm12),

                          Text(
                            slide.subtitle,
                            style: AppTextStyles.bodyL.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.pill,
                      color: _currentPage == i
                          ? AppColors.neonPink
                          : AppColors.bubblePink,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl40),

              // Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg32,
                ),
                child: AppButton(
                  label: _currentPage == _slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onTap: () {
                    if (_currentPage < _slides.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                    } else {
                      context.go(RouteNames.interestSelector);
                    }
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.md16),

              // Sign in link
              TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: Text(
                  'Already have an account? Sign In',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.neonPink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
