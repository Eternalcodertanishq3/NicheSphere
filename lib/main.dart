import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Firebase
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics — catch all Flutter + platform errors
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance
        .recordError(error, stack, fatal: true);
    return true;
  };

  // Hive local cache
  await Hive.initFlutter();
  await Hive.openBox('settings'); // onboarding flag, theme prefs
  await Hive.openBox('events_cache'); // last 50 home feed events
  await Hive.openBox('user_cache'); // current user profile

  // Initialize Background Geofencing Task
  await BackgroundService.initialize();
  BackgroundService.registerGeofenceTask();

  // System UI initial state
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const ProviderScope(child: NicheSphereApp()));
}

/// NicheSphere — Hyperlocal Micro-Community Event Discovery
class NicheSphereApp extends ConsumerWidget {
  const NicheSphereApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'NicheSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports auto-switching
      routerConfig: router,
      builder: (context, child) {
        // Update status bar brightness dynamically
        final brightness = MediaQuery.of(context).platformBrightness;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness,
        ));
        return child!;
      },
    );
  }
}
