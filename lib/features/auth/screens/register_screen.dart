import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';

/// NicheSphere — Register Screen (Screen 6)
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg24),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg32),
                Text('Create Account', style: AppTextStyles.displayL).animate().fadeIn(),
                const SizedBox(height: AppSpacing.xs4),
                Text('Join the community', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.lg32),
                GlassCard(
                  blur: 20, opacity: 0.25, borderRadius: AppBorderRadius.xl,
                  padding: const EdgeInsets.all(AppSpacing.lg24),
                  child: Column(children: [
                    _field('Full Name', Icons.person_outline_rounded),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Username', Icons.alternate_email_rounded),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Email', Icons.email_outlined),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Password', Icons.lock_outline_rounded, obscure: true),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Confirm Password', Icons.lock_outline_rounded, obscure: true),
                    const SizedBox(height: AppSpacing.md20),
                    AppButton(label: 'Sign Up', onTap: () => context.go(RouteNames.home)),
                  ]),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.lg24),
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: RichText(text: TextSpan(style: AppTextStyles.bodyM, children: const [
                    TextSpan(text: 'Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                    TextSpan(text: 'Sign In', style: TextStyle(color: AppColors.neonPink, fontWeight: FontWeight.w600)),
                  ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String hint, IconData icon, {bool obscure = false}) {
    return ClipRRect(
      borderRadius: AppBorderRadius.md,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          obscureText: obscure, style: AppTextStyles.bodyM,
          decoration: InputDecoration(
            hintText: hint, prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
            filled: true, fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(borderRadius: AppBorderRadius.md, borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
            enabledBorder: OutlineInputBorder(borderRadius: AppBorderRadius.md, borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
        ),
      ),
    );
  }
}
