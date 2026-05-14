import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/glass_text_field.dart';
import '../providers/auth_provider.dart';

/// NicheSphere — Login Screen (Screen 6)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _signIn() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) return;

    final error = await ref.read(authNotifierProvider.notifier).signIn(email, password);
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else if (mounted) {
      context.go(RouteNames.home);
    }
  }

  void _googleSignIn() async {
    final error = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else if (mounted) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg24),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AppBackButton(),
                ),
                const SizedBox(height: AppSpacing.lg24),
                // Logo
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple]),
                    boxShadow: [BoxShadow(color: AppColors.neonPink.withValues(alpha: 0.3), blurRadius: 20)],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
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
                      GlassTextField(
                        label: 'Email',
                        hintText: 'your@email.com',
                        controller: _emailCtrl,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppSpacing.md16),
                      GlassTextField(
                        label: 'Password',
                        hintText: '••••••••',
                        controller: _passwordCtrl,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
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
                        label: isLoading ? 'Signing In...' : 'Sign In',
                        isDisabled: isLoading,
                        onTap: _signIn,
                        gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonPurple]),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.lg24),
                // Divider
                Row(children: [
                  Expanded(child: Divider(color: AppColors.textHint.withValues(alpha: 0.3))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md16),
                    child: Text('or continue with', style: AppTextStyles.bodyS)),
                  Expanded(child: Divider(color: AppColors.textHint.withValues(alpha: 0.3))),
                ]),
                const SizedBox(height: AppSpacing.lg24),
                // Social auth buttons
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: isLoading ? null : _googleSignIn,
                    child: _buildSocialButton(Icons.public_rounded, 'Google'),
                  ),
                  const SizedBox(width: AppSpacing.md16),
                  _buildSocialButton(Icons.apple_rounded, 'Apple'),
                ]),
                const SizedBox(height: AppSpacing.lg32),
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: RichText(text: TextSpan(style: AppTextStyles.bodyM, children: const [
                    TextSpan(text: 'New to NicheSphere? ', style: TextStyle(color: AppColors.textSecondary)),
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
