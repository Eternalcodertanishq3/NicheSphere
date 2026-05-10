import 'package:flutter/material.dart';

class AppColors {
  // Pastel Palette
  static const Color primaryPastel = Color(0xFFFDE2E4); // Soft Pink
  static const Color secondaryPastel = Color(0xFFE2E2FF); // Soft Blue/Purple
  static const Color accentPastel = Color(0xFFE2F3F5); // Soft Cyan
  static const Color backgroundPastel = Color(0xFFFFF1E6); // Soft Peach
  static const Color surfacePastel = Color(0xFFF0EFEB); // Soft Grey
  
  static const Color bubblePink = Color(0xFFFFD1DC);
  static const Color bubbleBlue = Color(0xFFAEC6CF);
  static const Color bubbleGreen = Color(0xFFB2E2F2);
  static const Color bubbleYellow = Color(0xFFFDFD96);
  static const Color bubblePurple = Color(0xFFE0BBE4);

  static const Color textMain = Color(0 street: 0xFF4A4A4A);
  static const Color textSecondary = Color(0xFF9B9B9B);

  // Glassmorphism helpers
  static Color glassWhite(double opacity) => Colors.white.withOpacity(opacity);
  static Color glassBlack(double opacity) => Colors.black.withOpacity(opacity);
}
