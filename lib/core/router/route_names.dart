/// NicheSphere — Route Names
/// All routes via these constants — no raw string paths in context.go().
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String interestSelector = '/interests';
  static const String locationPermission = '/location-permission';
  static const String notificationPermission = '/notification-permission';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String createEvent = '/create-event';
  static const String inbox = '/inbox';
  static const String profile = '/profile';
  static const String eventDetails = '/event/:id';
  static const String communityDetails = '/community/:id';
  static const String chatRoom = '/chat/:id';
  static const String editProfile = '/edit-profile';
  static const String badges = '/badges';
  static const String settings = '/settings';
  static const String communities = '/communities';
  static const String mapView = '/map';
  static const String notifications = '/notifications';
  static const String followers = '/followers';
  static const String privacy = '/privacy';
  static const String blockedUsers = '/blocked-users';
}
