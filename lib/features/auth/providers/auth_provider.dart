// NicheSphere — Auth Provider (Phase 2)
// Handles sign-in, register, Google SSO, and sign-out flows.
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/user_model.dart';

/// Auth state notifier — manages async auth operations.
class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authServiceProvider)
        .signInWithEmail(email, password);
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return failure.message;
      },
      (user) {
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    final authResult = await ref
        .read(authServiceProvider)
        .registerWithEmail(
            email: email, password: password, name: name);
    return authResult.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return failure.message;
      },
      (user) async {
        // Create Firestore user document
        final userRepo = ref.read(userRepositoryProvider);
        await userRepo.createUserDocument(UserModel(
          id: user.uid,
          name: name,
          username: email.split('@').first.toLowerCase(),
          email: email,
          createdAt: DateTime.now(),
        ));
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<String?> signInWithGoogle() async {
    state = const AsyncLoading();
    final result =
        await ref.read(authServiceProvider).signInWithGoogle();
    return result.fold(
      (f) {
        state = AsyncError(f.message, StackTrace.current);
        return f.message;
      },
      (_) {
        state = const AsyncData(null);
        return null;
      },
    );
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    Hive.box('settings').delete('onboarding_complete');
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, void>(() => AuthNotifier());
