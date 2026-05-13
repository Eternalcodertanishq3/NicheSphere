import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp();
      
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      // Use position in future geo-queries
      debugPrint('Polled location: ${position.latitude}, ${position.longitude}');

      // Simulated query to find "Hot Spheres" based on current location
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('startAt', isGreaterThan: DateTime.now())
          .limit(10)
          .get();

      // For MVP, if we find any nearby upcoming events, fire notification.
      if (snapshot.docs.isNotEmpty) {
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);
        
        await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'hot_sphere_channel',
          'Hot Spheres',
          channelDescription: 'Notifications for high event density areas',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        
        await flutterLocalNotificationsPlugin.show(
          id: 0,
          title: 'You just entered a Hot Sphere! 🔥',
          body: '${snapshot.docs.length} upcoming events near your current location. Tap to discover.',
          notificationDetails: platformChannelSpecifics,
          payload: 'hot_sphere',
        );
      }
      return Future.value(true);
    } catch (err) {
      return Future.value(false);
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  static void registerGeofenceTask() {
    Workmanager().registerPeriodicTask(
      "1",
      "geofence_hot_sphere_check",
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
