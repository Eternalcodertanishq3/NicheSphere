// NicheSphere — Notification Service (Phase 2)
// FCM push notifications + local scheduled notifications.
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    tz.initializeTimeZones();

    // Local notifications init
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    // FCM permissions
    await _fcm.requestPermission();

    // Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title ?? 'NicheSphere',
          body: message.notification!.body ?? '',
        );
      }
    });
  }

  Future<String?> getFcmToken() => _fcm.getToken();

  Future<void> scheduleEventReminder({
    required int id,
    required String title,
    required DateTime eventTime,
  }) async {
    final reminderTime = tz.TZDateTime.from(
      eventTime.subtract(const Duration(hours: 24)),
      tz.local,
    );
    if (reminderTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _local.zonedSchedule(
      id: id,
      title: '🗓️ Tomorrow: $title',
      body: 'Your event starts in 24 hours!',
      scheduledDate: reminderTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'Event Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(int id) => _local.cancel(id: id);

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    await _local.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'general',
          'General',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
