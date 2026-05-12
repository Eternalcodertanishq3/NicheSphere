/// NicheSphere — Onboarding Provider (Phase 2)
library;

/// Manages interest selection and onboarding completion.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/di/providers.dart';

class OnboardingNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String interest) {
    if (state.contains(interest)) {
      state = {...state}..remove(interest);
    } else {
      state = {...state, interest};
    }
  }

  Future<bool> completeOnboarding() async {
    if (state.length < 3) return false;
    final repo = ref.read(userRepositoryProvider);
    final result = await repo.saveInterests(state.toList());
    return result.fold((_) => false, (_) {
      Hive.box('settings').put('onboarding_complete', true);
      Hive.box('settings').put('interests', state.toList());
      return true;
    });
  }
}

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, Set<String>>(
        () => OnboardingNotifier());
