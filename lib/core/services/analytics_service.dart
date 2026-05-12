/// NicheSphere — Analytics Service (Phase 2)
/// Firebase Analytics event logging.
library;

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  Future<void> logEventViewed(String eventId) => _analytics
      .logEvent(name: 'event_viewed', parameters: {'event_id': eventId});

  Future<void> logEventRsvp(String eventId) => _analytics
      .logEvent(name: 'event_rsvp', parameters: {'event_id': eventId});

  Future<void> logEventCreated(String category) => _analytics
      .logEvent(name: 'event_created', parameters: {'category': category});

  Future<void> logCommunityJoined(String communityId) => _analytics.logEvent(
      name: 'community_joined', parameters: {'community_id': communityId});

  Future<void> logSearch(String query) =>
      _analytics.logSearch(searchTerm: query);

  Future<void> logBadgeEarned(String badgeId) => _analytics
      .logEvent(name: 'badge_earned', parameters: {'badge_id': badgeId});
}
