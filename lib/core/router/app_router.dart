import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'route_names.dart';
import '../di/providers.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/interest_selector_screen.dart';
import '../../features/onboarding/screens/location_permission_screen.dart';
import '../../features/onboarding/screens/notification_permission_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/event_details/screens/event_details_screen.dart';
import '../../features/create_event/screens/create_event_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/communities/screens/communities_screen.dart';
import '../../features/chat/screens/inbox_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/badges_screen.dart';

/// NicheSphere — App Router (GoRouter) with auth guards.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      // Try to read auth state from the ProviderScope
      try {
        final container = ProviderScope.containerOf(context);
        final authState = container.read(authStateProvider);
        final isLoggedIn = authState.value != null;
        final isOnboarded = Hive.box('settings')
            .get('onboarding_complete', defaultValue: false) as bool;

        final currentPath = state.matchedLocation;
        final goingToAuth = currentPath.startsWith('/login') ||
            currentPath.startsWith('/register') ||
            currentPath.startsWith('/welcome') ||
            currentPath.startsWith('/interests');
        final isOnSplash = currentPath == '/';

        // Don't redirect on splash — let it handle its own navigation
        if (isOnSplash) return null;

        if (!isLoggedIn && !goingToAuth) return RouteNames.welcome;
        if (isLoggedIn && !isOnboarded && !goingToAuth) {
          return RouteNames.interestSelector;
        }
        if (isLoggedIn && goingToAuth) return RouteNames.home;
      } catch (_) {
        // Provider not available yet (e.g., during splash)
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        pageBuilder: (context, state) =>
            _buildPage(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: RouteNames.interestSelector,
        name: 'interests',
        pageBuilder: (context, state) =>
            _buildPage(state, const InterestSelectorScreen()),
      ),
      GoRoute(
        path: RouteNames.locationPermission,
        name: 'locationPermission',
        pageBuilder: (context, state) =>
            _buildPage(state, const LocationPermissionScreen()),
      ),
      GoRoute(
        path: RouteNames.notificationPermission,
        name: 'notificationPermission',
        pageBuilder: (context, state) =>
            _buildPage(state, const NotificationPermissionScreen()),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) =>
            _buildPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) =>
            _buildPage(state, const RegisterScreen()),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        pageBuilder: (context, state) =>
            _buildPage(state, const HomeScreen()),
      ),
      GoRoute(
        path: RouteNames.explore,
        name: 'explore',
        pageBuilder: (context, state) =>
            _buildPage(state, const ExploreScreen()),
      ),
      GoRoute(
        path: RouteNames.createEvent,
        name: 'createEvent',
        pageBuilder: (context, state) =>
            _buildPage(state, const CreateEventScreen()),
      ),
      GoRoute(
        path: RouteNames.inbox,
        name: 'inbox',
        pageBuilder: (context, state) =>
            _buildPage(state, const InboxScreen()),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        pageBuilder: (context, state) =>
            _buildPage(state, const ProfileScreen()),
      ),
      GoRoute(
        path: '/event/:id',
        name: 'eventDetails',
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['id'] ?? '';
          return _buildPage(
              state, EventDetailsScreen(eventId: eventId));
        },
      ),
      GoRoute(
        path: RouteNames.communities,
        name: 'communities',
        pageBuilder: (context, state) =>
            _buildPage(state, const CommunitiesScreen()),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        pageBuilder: (context, state) =>
            _buildPage(state, const NotificationsScreen()),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            _buildPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) =>
            _buildPage(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: RouteNames.badges,
        name: 'badges',
        pageBuilder: (context, state) =>
            _buildPage(state, const BadgesScreen()),
      ),
    ],
  );

  /// Standard page transition: FadeTransition + slight vertical slide (20px up), 300ms
  static CustomTransitionPage _buildPage(
      GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
