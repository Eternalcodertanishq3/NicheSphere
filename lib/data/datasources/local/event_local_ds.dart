/// NicheSphere — Event Local DataSource (Phase 2)
/// Hive-backed local cache for offline event data.
library;

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/event_model.dart';

class EventLocalDataSource {
  Box get _box => Hive.box('events_cache');

  List<EventModel> getCachedEvents() {
    return _getCachedList('featured_events');
  }

  Future<void> cacheEvents(List<EventModel> events) async {
    await _cacheList('featured_events', events);
  }

  List<EventModel> getCachedNearbyEvents() {
    return _getCachedList('nearby_events');
  }

  Future<void> cacheNearbyEvents(List<EventModel> events) async {
    await _cacheList('nearby_events', events);
  }

  List<EventModel> _getCachedList(String key) {
    try {
      final raw = _box.get(key);
      if (raw == null) return [];
      final list = jsonDecode(raw as String) as List;
      return list.map((e) => EventModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheList(String key, List<EventModel> events) async {
    final limited = events.take(50).toList();
    await _box.put(
        key, jsonEncode(limited.map((e) => e.toJson()).toList()));
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
