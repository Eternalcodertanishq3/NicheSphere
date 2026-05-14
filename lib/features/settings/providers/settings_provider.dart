/// NicheSphere — Settings Provider (Phase 2)
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/di/providers.dart';

class SettingsNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<String?> updateProfile(Map<String, dynamic> fields) async {
    state = const AsyncLoading();
    final result = await ref.read(userRepositoryProvider).updateUser(fields);
    debugPrint('DEBUG: Profile Update Result: ${result.isRight()}');
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
    Hive.box('settings').clear();
    Hive.box('user_cache').clear();
    Hive.box('events_cache').clear();
  }

  Future<String?> deleteAccount() async {
    state = const AsyncLoading();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      await Hive.box('settings').clear();
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      return 'Failed to delete account. You may need to re-authenticate.';
    }
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, void>(
        () => SettingsNotifier());
