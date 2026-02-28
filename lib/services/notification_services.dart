import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  static Future requestPermission() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<bool> isPermissionGranted() async {
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      final granted = await androidImpl.areNotificationsEnabled();
      return granted ?? false;
    }

    // For iOS and other platforms, assume granted if no Android implementation
    return true;
  }

  static Future scheduleNextNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    final random = Random();

    // SMART QUIET HOURS (no notifications between 11 PM – 9 AM)
    bool isQuietHour(int hour) => hour >= 23 || hour < 9;

    DateTime scheduled;

    if (now.weekday == DateTime.saturday) {
      // Saturday around 9 PM
      scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        21,
        random.nextInt(20),
      );
    } else {
      // Random notification every 2 days
      final future = now.add(const Duration(days: 2));

      int hour;
      do {
        hour = random.nextInt(24);
      } while (isQuietHour(hour));

      scheduled = DateTime(
        future.year,
        future.month,
        future.day,
        hour,
        random.nextInt(60),
      );
    }

    final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

    try {
      await _notifications.zonedSchedule(
        0,
        "Still alone?",
        "",
        tzScheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'still_alone_channel',
            'Still Alone Notifications',
            channelDescription: 'Soft elegant reminders',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFD1C4E9),
            colorized: true,
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            styleInformation: DefaultStyleInformation(true, true),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // Fallback in case exact alarms are restricted on device
      await _notifications.show(
        0,
        "Still alone?",
        "",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'still_alone_channel',
            'Still Alone Notifications',
            channelDescription: 'Soft elegant reminders',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFFD1C4E9),
            colorized: true,
          ),
        ),
      );
    }
  }
}