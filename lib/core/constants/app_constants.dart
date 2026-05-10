/// NicheSphere — App Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'NicheSphere';
  static const String appTagline = 'Hyperlocal Micro-Communities';
  static const int minInterests = 3;
  static const int splashDurationMs = 3000;
  static const int maxEventImages = 5;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 20;
  static const int debounceMs = 500;
  static const double defaultMapZoom = 14.0;
  static const int homeFeedCacheLimit = 50;

  /// Interest categories with their emoji and neon group
  static const List<Map<String, String>> interests = [
    {'name': 'Art', 'emoji': '🎨', 'neon': 'pink'},
    {'name': 'Reading', 'emoji': '📚', 'neon': 'blue'},
    {'name': 'Movies', 'emoji': '🎬', 'neon': 'purple'},
    {'name': 'Gaming', 'emoji': '🎮', 'neon': 'blue'},
    {'name': 'Photography', 'emoji': '📷', 'neon': 'pink'},
    {'name': 'Travel', 'emoji': '✈️', 'neon': 'orange'},
    {'name': 'Fashion', 'emoji': '👗', 'neon': 'pink'},
    {'name': 'Fitness', 'emoji': '💪', 'neon': 'green'},
    {'name': 'Anime', 'emoji': '🌸', 'neon': 'pink'},
    {'name': 'Cooking', 'emoji': '🍳', 'neon': 'orange'},
    {'name': 'Sci-Fi', 'emoji': '🚀', 'neon': 'blue'},
    {'name': 'Tech', 'emoji': '💻', 'neon': 'green'},
    {'name': 'Comics', 'emoji': '💥', 'neon': 'blue'},
    {'name': 'Nature', 'emoji': '🌿', 'neon': 'green'},
    {'name': 'K-Pop', 'emoji': '🎤', 'neon': 'purple'},
    {'name': 'Design', 'emoji': '✏️', 'neon': 'green'},
    {'name': 'Writing', 'emoji': '✍️', 'neon': 'purple'},
    {'name': 'Music', 'emoji': '🎵', 'neon': 'purple'},
    {'name': 'History', 'emoji': '🏛️', 'neon': 'orange'},
    {'name': 'Coffee', 'emoji': '☕', 'neon': 'orange'},
    {'name': 'D&D', 'emoji': '🐉', 'neon': 'blue'},
    {'name': 'Sports', 'emoji': '⚽', 'neon': 'green'},
    {'name': 'Hiking', 'emoji': '🥾', 'neon': 'green'},
    {'name': 'Pets', 'emoji': '🐾', 'neon': 'orange'},
    {'name': 'DIY', 'emoji': '🔨', 'neon': 'orange'},
    {'name': 'Plants', 'emoji': '🌱', 'neon': 'green'},
    {'name': 'Vintage', 'emoji': '📻', 'neon': 'purple'},
    {'name': 'Streetwear', 'emoji': '👟', 'neon': 'pink'},
    {'name': 'Crypto', 'emoji': '₿', 'neon': 'green'},
  ];

  /// Category list with emojis for the home screen chips
  static const List<Map<String, String>> categories = [
    {'name': 'All', 'emoji': '🏠'},
    {'name': 'Gaming', 'emoji': '🎮'},
    {'name': 'Fitness', 'emoji': '💪'},
    {'name': 'Art', 'emoji': '🎨'},
    {'name': 'Tech', 'emoji': '💻'},
    {'name': 'Cooking', 'emoji': '🍳'},
    {'name': 'Music', 'emoji': '🎵'},
    {'name': 'Wellness', 'emoji': '🧘'},
    {'name': 'Books', 'emoji': '📚'},
    {'name': 'Pets', 'emoji': '🐾'},
    {'name': 'Coffee', 'emoji': '☕'},
    {'name': 'Events', 'emoji': '🎭'},
  ];
}
