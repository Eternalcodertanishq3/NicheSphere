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
final routerProvider = Provider<GoRouter>((ref) {
  // We use ref.listen to refresh the router without re-creating the entire instance
  // This is the key to preventing the "Redirect loop detected" error
  final router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) => AuthGuard.handle(ref, state),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
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
        pageBuilder: (context, state) => _buildPage(state, const LoginScreen()),
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
        pageBuilder: (context, state) => _buildPage(state, const HomeScreen()),
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
        pageBuilder: (context, state) => _buildPage(state, const InboxScreen()),
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
          return _buildPage(state, EventDetailsScreen(eventId: eventId));
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

  // This ensures the router re-runs its redirection whenever auth state changes
  ref.listen(authStateProvider, (previous, next) {
    router.refresh();
  });

  return router;
});

/// Standard page transition: FadeTransition + slight vertical slide (20px up), 300ms
CustomTransitionPage _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

/// NicheSphere — AuthGuard helper for centralizing redirection logic.
class AuthGuard {
  static String? handle(Ref ref, GoRouterState state) {
    final authState = ref.read(authStateProvider);

    // If auth is still loading, stay on Splash
    if (authState.isLoading) return null;

    final isLoggedIn = authState.value != null;

    // Safe box access: check if open, otherwise return null (will try again next tick)
    if (!Hive.isBoxOpen('settings')) return null;

    final isOnboarded = Hive.box('settings')
        .get('onboarding_complete', defaultValue: false) as bool;
    final currentPath = state.matchedLocation;

    // Define our route groups
    final isAuthPath = currentPath == RouteNames.welcome ||
        currentPath == RouteNames.login ||
        currentPath == RouteNames.register;

    final isOnboardingPath = currentPath == RouteNames.interestSelector ||
        currentPath == RouteNames.locationPermission ||
        currentPath == RouteNames.notificationPermission;

    // 1. Not Logged In?
    if (!isLoggedIn) {
      if (isAuthPath) return null;
      return RouteNames.welcome;
    }

    // 2. Logged In but Not Onboarded?
    if (!isOnboarded) {
      if (isOnboardingPath) return null;
      return RouteNames.interestSelector;
    }

    // 3. Logged In and Fully Onboarded?
    // If they are on Auth/Onboarding/Splash/Welcome screens, send them Home.
    if (isAuthPath ||
        isOnboardingPath ||
        currentPath == RouteNames.welcome ||
        currentPath == RouteNames.splash) {
      return RouteNames.home;
    }

    return null;
  }
}
