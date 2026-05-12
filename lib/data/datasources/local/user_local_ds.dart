/// NicheSphere — User Local DataSource (Phase 2)
/// Hive-backed local cache for current user profile.
library;

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user_model.dart';

class UserLocalDataSource {
  Box get _box => Hive.box('user_cache');

  UserModel? getCachedUser() {
    try {
      final raw = _box.get('current_user');
      if (raw == null) return null;
      return UserModel.fromJson(jsonDecode(raw as String));
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheUser(UserModel user) async {
    await _box.put('current_user', jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
