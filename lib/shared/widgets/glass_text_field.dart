import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_border_radius.dart';
import 'glass_card.dart';

/// NicheSphere — Reusable Glassmorphic Text Field
/// 
/// A premium, themed input field with glassmorphism and focus effects.
class GlassTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const GlassTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onChanged,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: GlassCard(
            blur: 12,
            opacity: _isFocused ? 0.25 : 0.15,
            borderRadius: AppBorderRadius.md,
            padding: EdgeInsets.zero,
            glowColor: _isFocused ? AppColors.neonPink : null,
            glowIntensity: _isFocused ? 0.1 : 0,
            onTap: widget.onTap,
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              obscureText: widget.isPassword,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              validator: widget.validator,
              onChanged: widget.onChanged,
              style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
              cursorColor: AppColors.neonPink,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textHint),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: _isFocused ? AppColors.neonPink : AppColors.textHint, size: 20)
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(widget.suffixIcon,
                            color: _isFocused
                                ? AppColors.neonPink
                                : AppColors.textHint,
                            size: 20),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
