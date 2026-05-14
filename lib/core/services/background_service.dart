import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import '../config/firebase_options.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      // 1. Safe Firebase Initialization
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      
      debugPrint('Background Polled location: ${position.latitude}, ${position.longitude}');

      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('startAt', isGreaterThan: DateTime.now())
          .limit(10)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        
        // 2. Multi-platform Notification Settings
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        const DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        
        const InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );
        
        await flutterLocalNotificationsPlugin.initialize(
          settings: initializationSettings,
        );

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'hot_sphere_channel',
          'Hot Spheres',
          channelDescription: 'Notifications for high event density areas',
          importance: Importance.max,
          priority: Priority.high,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        
        await flutterLocalNotificationsPlugin.show(
          id: 0,
          title: 'Hot Sphere Nearby! 🔥',
          body: 'Found ${snapshot.docs.length} events near you. Tap to explore!',
          notificationDetails: platformChannelSpecifics,
        );
      }
      return Future.value(true);
    } catch (err) {
      debugPrint('Background task error: $err');
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static void registerGeofenceTask() {
    Workmanager().registerPeriodicTask(
      "geofence_task",
      "geofence_hot_sphere_check",
      // 3. Increased interval to 1 hour to save battery
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
}
