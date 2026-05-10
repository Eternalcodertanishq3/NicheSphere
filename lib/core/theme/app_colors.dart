import 'package:flutter/material.dart';

/// NicheSphere Design System — Color Palette
/// All colors must be referenced from this class. No hardcoded hex values in widgets.
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────
  static const Color bgPrimary = Color(0xFFFFF8F0); // Warm peach-white
  static const Color bgSecondary = Color(0xFFFFF1E6); // Soft peach
  static const Color bgTertiary = Color(0xFFFDE8D8); // Deeper peach

  // ── Pastel Gradients (use in LinearGradient) ─────
  static const Color gradStart = Color(0xFFFFF1E6); // Peach
  static const Color gradMid = Color(0xFFFFE4F0); // Blush pink
  static const Color gradEnd = Color(0xFFE8E4FF); // Soft lavender

  // ── Glass surfaces ───────────────────────────────
  static const Color glassWhite = Color(0xCCFFFFFF); // 80% white
  static const Color glassPink = Color(0x33FFB3C6); // 20% pink
  static const Color glassBlue = Color(0x33B3C6FF); // 20% blue

  // ── Neon Glow (selected states, CTAs) ────────────
  static const Color neonBlue = Color(0xFF6C8EFF); // Gaming
  static const Color neonPink = Color(0xFFFF6CB0); // Anime/Art
  static const Color neonGreen = Color(0xFF5BFFC8); // Tech
  static const Color neonPurple = Color(0xFFB06CFF); // Music
  static const Color neonOrange = Color(0xFFFFB06C); // Food/Travel

  // ── Bubble Pastels (unselected tags) ─────────────
  static const Color bubblePink = Color(0xFFFFD6E7);
  static const Color bubbleBlue = Color(0xFFD6E4FF);
  static const Color bubbleGreen = Color(0xFFD6FFF0);
  static const Color bubbleYellow = Color(0xFFFFFAD6);
  static const Color bubblePurple = Color(0xFFEDD6FF);
  static const Color bubbleMint = Color(0xFFD6FFF9);
  static const Color bubblePeach = Color(0xFFFFE8D6);

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D2D3A);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textHint = Color(0xFFAAAAAF);
  static const Color textOnDark = Color(0xFFF8F8FF);

  // ── Semantic ──────────────────────────────────────
  static const Color success = Color(0xFF5BFFC8);
  static const Color warning = Color(0xFFFFD96C);
  static const Color error = Color(0xFFFF6C8E);
  static const Color info = Color(0xFF6CB0FF);

  /// Get neon color for a category
  static Color neonForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'gaming':
        return neonBlue;
      case 'anime':
      case 'art':
      case 'fashion':
      case 'photography':
        return neonPink;
      case 'tech':
      case 'crypto':
      case 'design':
        return neonGreen;
      case 'music':
      case 'k-pop':
        return neonPurple;
      case 'food':
      case 'travel':
      case 'cooking':
      case 'coffee':
        return neonOrange;
      default:
        return neonBlue;
    }
  }

  /// Get pastel bubble color for an interest index
  static Color bubbleForIndex(int index) {
    const bubbles = [
      bubblePink,
      bubbleBlue,
      bubbleGreen,
      bubbleYellow,
      bubblePurple,
      bubbleMint,
      bubblePeach,
    ];
    return bubbles[index % bubbles.length];
  }
}
