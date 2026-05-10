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

/// NicheSphere — Login Screen (Screen 6)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg24),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl48),
                // Logo
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple]),
                    boxShadow: [BoxShadow(color: AppColors.neonPink.withOpacity(0.3), blurRadius: 20)],
                  ),
                  child: const Icon(Icons.blur_on_rounded, size: 40, color: Colors.white),
                ).animate().scale(begin: const Offset(0.8, 0.8), duration: 500.ms, curve: Curves.easeOutCubic),
                const SizedBox(height: AppSpacing.lg24),
                Text('Welcome Back', style: AppTextStyles.displayL).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.xs4),
                Text('Sign in to continue', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary))
                    .animate().fadeIn(delay: 300.ms),
                const SizedBox(height: AppSpacing.lg32),
                // Glass card form
                GlassCard(
                  blur: 20, opacity: 0.25, borderOpacity: 0.4,
                  borderRadius: AppBorderRadius.xl,
                  padding: const EdgeInsets.all(AppSpacing.lg24),
                  child: Column(
                    children: [
                      _buildTextField(hint: 'Email', icon: Icons.email_outlined),
                      const SizedBox(height: AppSpacing.md16),
                      _buildTextField(hint: 'Password', icon: Icons.lock_outline_rounded, obscure: true),
                      const SizedBox(height: AppSpacing.xs8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot password?', style: AppTextStyles.bodyS.copyWith(color: AppColors.neonPink)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md16),
                      AppButton(
                        label: 'Sign In',
                        onTap: () => context.go(RouteNames.home),
                        gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple]),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.lg24),
                // Divider
                Row(children: [
                  Expanded(child: Divider(color: AppColors.textHint.withOpacity(0.3))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md16),
                    child: Text('or continue with', style: AppTextStyles.bodyS)),
                  Expanded(child: Divider(color: AppColors.textHint.withOpacity(0.3))),
                ]),
                const SizedBox(height: AppSpacing.lg24),
                // Social auth buttons
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _buildSocialButton(Icons.public_rounded, 'Google'),
                  const SizedBox(width: AppSpacing.md16),
                  _buildSocialButton(Icons.apple_rounded, 'Apple'),
                ]),
                const SizedBox(height: AppSpacing.lg32),
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: RichText(text: TextSpan(style: AppTextStyles.bodyM, children: [
                    const TextSpan(text: 'New to NicheSphere? ', style: TextStyle(color: AppColors.textSecondary)),
                    TextSpan(text: 'Sign Up', style: TextStyle(color: AppColors.neonPink, fontWeight: FontWeight.w600)),
                  ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool obscure = false}) {
    return ClipRRect(
      borderRadius: AppBorderRadius.md,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          obscureText: obscure,
          style: AppTextStyles.bodyM,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.md,
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.md,
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return GlassCard(
      blur: 15, opacity: 0.2, borderOpacity: 0.3,
      borderRadius: AppBorderRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24, vertical: AppSpacing.sm12),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 24, color: AppColors.textPrimary),
        const SizedBox(width: AppSpacing.xs8),
        Text(label, style: AppTextStyles.titleM),
      ]),
    );
  }
}
