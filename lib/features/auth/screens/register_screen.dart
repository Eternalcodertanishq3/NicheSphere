import 'dart:ui';
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
import '../providers/auth_provider.dart';

/// NicheSphere — Register Screen (Screen 6)
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passwordCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  void _register() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final error = await ref.read(authNotifierProvider.notifier)
        .register(email: email, password: password, name: name);
    
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else if (mounted) {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
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
                    _field('Full Name', Icons.person_outline_rounded, _nameCtrl),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Email', Icons.email_outlined, _emailCtrl),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Password', Icons.lock_outline_rounded, _passwordCtrl, obscure: true),
                    const SizedBox(height: AppSpacing.sm12),
                    _field('Confirm Password', Icons.lock_outline_rounded, _confirmCtrl, obscure: true),
                    const SizedBox(height: AppSpacing.md20),
                    AppButton(
                      label: isLoading ? 'Creating Account...' : 'Sign Up',
                      isDisabled: isLoading,
                      onTap: _register,
                    ),
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

  Widget _field(String hint, IconData icon, TextEditingController ctrl, {bool obscure = false}) {
    return ClipRRect(
      borderRadius: AppBorderRadius.md,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: ctrl,
          obscureText: obscure, style: AppTextStyles.bodyM,
          decoration: InputDecoration(
            hintText: hint, prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
            filled: true, fillColor: Colors.white.withValues(alpha: 0.5),
            border: OutlineInputBorder(borderRadius: AppBorderRadius.md, borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
            enabledBorder: OutlineInputBorder(borderRadius: AppBorderRadius.md, borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
          ),
        ),
      ),
    );
  }
}
