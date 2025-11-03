import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class Notifications {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the plugin
  Future<void> initNotification() async {
    if (_isInitialized) return; // Already initialized

    // Initialize timezone
    tz.initializeTimeZones();
    final currentTimezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimezone = currentTimezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(currentTimezone));

    // Initialize Android settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/app_icon');

    // Initialize iOS settings
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize settings
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);

    _isInitialized = true;
  }

  /// Set up Notification detail
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
  }

  /// Show instant notification
  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notificationsPlugin.show(id, title, body, notificationDetails());
  }

  /// Schedule a notification at a specific time
  Future<void> scheduleNotification(
      {int id = 1,
      required String title,
      required String body,
      required int hour,
      required int minute}) async {
    // Get the current date/time device's local timezone
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedule a notification for upcoming tasks count
  Future<void> scheduleUpcomingTasksNotification({
    required int taskCount,
    int id = 2,
    int hour = 9,
    int minute = 0,
  }) async {
    if (taskCount <= 0) {
      // Cancel notification if no tasks
      await cancelNotification(id);
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = taskCount == 1
        ? 'You have 1 upcoming task today'
        : 'You have $taskCount upcoming tasks today';
    final body = taskCount == 1
        ? 'Don\'t forget to complete your task!'
        : 'Don\'t forget to complete your tasks!';

    await notificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  /// Cancel a specific notification by id
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
