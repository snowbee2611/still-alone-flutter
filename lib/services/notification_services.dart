import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'still_alone_channel_v3';
  static const String _channelName = 'Still Alone';
  static const String _channelDescription =
      'Soft emotional reminders';

  // ================= INIT =================

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  // ================= PERMISSION =================

  static Future<void> requestPermission() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<bool> isPermissionGranted() async {
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      final granted = await androidImpl.areNotificationsEnabled();
      return granted ?? false;
    }

    return true;
  }

  // ================= INSTANT AFTER ANSWER =================

  static Future<void> sendInstantAfterAnswer(String choice) async {
    final titles = _instantTitles(choice);
    final random = Random();

    final title = titles[random.nextInt(titles.length)];

    // Random delay 3–5 seconds
    final delaySeconds = 3 + random.nextInt(3);
    await Future.delayed(Duration(seconds: delaySeconds));

    await _show(title);
  }

  static List<String> _instantTitles(String choice) {
    switch (choice.toLowerCase()) {
      case 'yes':
        return [
          "Still?",
          "I remember.",
          "It's okay.",
          "Same answer?",
          "You said yes."
        ];
      case 'no':
        return [
          "Still no?",
          "Are you sure?",
          "Hmm.",
          "Interesting.",
          "Really?"
        ];
      default:
        return [
          "Still unsure?",
          "Thinking?",
          "Maybe?",
          "In between?",
          "Hmm..."
        ];
    }
  }

  // ================= WEEKLY NOTIFICATIONS =================

  static Future<void> scheduleWeeklyNotifications() async {
    final random = Random();
    final now = tz.TZDateTime.now(tz.local);

    // Cancel previous weekly notifications
    await _notifications.cancel(1001);
    await _notifications.cancel(1002);

    // 🔥 Pick 2 UNIQUE random days (0–6)
    final Set<int> selectedDays = {};

    while (selectedDays.length < 2) {
      selectedDays.add(random.nextInt(7));
    }

    int notificationId = 1001;

    for (final dayOffset in selectedDays) {
      final hour = 10 + random.nextInt(10); // 10AM–8PM
      final minute = random.nextInt(60);

      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).add(Duration(days: dayOffset));

      // 🔥 Ensure always future
      if (scheduledDate.isBefore(now)) {
        scheduledDate =
            scheduledDate.add(const Duration(days: 7));
      }

      await _notifications.zonedSchedule(
        notificationId,
        _weeklyTitle(),
        "",
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode:
        AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      notificationId++;
    }
  }

  static String _weeklyTitle() {
    final titles = [
      "Still there?",
      "Hey.",
      "Quick question.",
      "One thought.",
      "Just checking."
    ];

    final random = Random();
    return titles[random.nextInt(titles.length)];
  }

  // ================= ESCALATION =================

  static Future<void> checkInactivityEscalation() async {
    final prefs = await SharedPreferences.getInstance();

    final lastOpen =
        prefs.getInt('last_open_time') ?? 0;

    final lastChoice =
        prefs.getString('lastChoice') ?? '';

    final days =
        DateTime.now()
            .difference(
            DateTime.fromMillisecondsSinceEpoch(lastOpen))
            .inDays;

    if (days >= 14) {
      await _show(_strongFollowUp(lastChoice));
    } else if (days >= 7) {
      await _show(_softFollowUp(lastChoice));
    }
  }

  static String _softFollowUp(String choice) {
    switch (choice.toLowerCase()) {
      case 'yes':
        return "Still alone?";
      case 'no':
        return "Still no?";
      default:
        return "Still unsure?";
    }
  }

  static String _strongFollowUp(String choice) {
    switch (choice.toLowerCase()) {
      case 'yes':
        return "Still alone. Or hiding?";
      case 'no':
        return "Still pretending?";
      default:
        return "Still confused?";
    }
  }

  // ================= WELCOME =================

  static Future<void> showWelcomeNotification() async {
    await _show("Hey.");
  }

  // ================= CORE SHOW =================

  static Future<void> _show(String title) async {
    await _notifications.show(
      Random().nextInt(100000),
      title,
      "",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}