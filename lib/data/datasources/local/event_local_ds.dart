/// NicheSphere — Event Local DataSource (Phase 2)
/// Hive-backed local cache for offline event data.
library;

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/event_model.dart';

class EventLocalDataSource {
  Box get _box => Hive.box('events_cache');

  List<EventModel> getCachedEvents() {
    try {
      final raw = _box.get('featured_events');
      if (raw == null) return [];
      final list = jsonDecode(raw as String) as List;
      return list.map((e) => EventModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> cacheEvents(List<EventModel> events) async {
    final limited = events.take(50).toList();
    await _box.put(
        'featured_events', jsonEncode(limited.map((e) => e.toJson()).toList()));
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
