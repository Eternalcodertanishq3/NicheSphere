import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Preloads Lottie animations into memory for smooth playback.
Future<void> precacheLottieAssets(BuildContext context) async {
  final assets = [
    'assets/animations/success_check.json',
    'assets/animations/confetti_burst.json',
    'assets/animations/badge_pop.json',
  ];

  for (final asset in assets) {
    try {
      await precacheLottie(Lottie.asset(asset).decoder);
    } catch (e) {
      debugPrint('Failed to precache $asset: $e');
    }
  }
}
