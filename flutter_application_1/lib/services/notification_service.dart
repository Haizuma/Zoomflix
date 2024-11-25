import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  factory NotificationService() => instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      debugPrint('Initializing ZOOMFLIX notifications service...');

     
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      debugPrint('Timezone initialized');

      
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          debugPrint('Notification tapped: ${response.payload}');
        },
      );

      debugPrint('Notifications plugin initialized');
    } catch (e, stackTrace) {
      debugPrint('Error initializing notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> scheduleMovieNotifications() async {
    try {
      debugPrint('Cancelling existing notifications...');
      await notificationsPlugin.cancelAll();

      final List<Map<String, dynamic>> notificationSchedules = [
        {
          'hour': 14,
          'minute': 33,
          'title': 'Waktunya Nonton!',
          'message': 'Jangan lewatkan film favorit Anda malam ini di ZOOMFLIX!'
        },
        {
          'hour': 14,
          'minute': 32,
          'title': 'Rekomendasi Film Malam Ini',
          'message': 'Simak rekomendasi film malam ini hanya di ZOOMFLIX.'
        },
        {
          'hour': 14,
          'minute': 30,
          'title': 'Saatnya Bersantai',
          'message': 'Temukan film menarik untuk waktu istirahat siang Anda.'
        },
      ];

      debugPrint(
          'Scheduling ${notificationSchedules.length} movie notifications...');

      int id = 0;
      for (var schedule in notificationSchedules) {
        await scheduleNotification(
          id++,
          schedule['hour'],
          schedule['minute'],
          schedule['title'],
          schedule['message'],
        );
      }

      // Check pending notifications
      final List<PendingNotificationRequest> pendingNotifications =
          await notificationsPlugin.pendingNotificationRequests();
      debugPrint('Pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        debugPrint(
            'Scheduled: ID ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      debugPrint('Error scheduling movie notifications: $e');
    }
  }

  Future<void> scheduleNotification(
    int id,
    int hour,
    int minute,
    String title,
    String message,
  ) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'zoomflix_channel_$id',
        'Zoomflix Notifications',
        channelDescription: 'Daily movie recommendations and reminders',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(message),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      debugPrint('Scheduling notification ID $id for: $scheduledDate');

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Successfully scheduled notification ID $id');
    } catch (e) {
      debugPrint('Error scheduling notification ID $id: $e');
    }
  }

  Future<void> showInstantNotification(String title, String message) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Notifications for immediate display',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(message),
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await notificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        message,
        platformDetails,
      );

      debugPrint('Instant notification sent successfully');
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
    }
  }
}
