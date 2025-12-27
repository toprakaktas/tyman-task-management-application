import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final Notifications _instance = Notifications._internal();
  factory Notifications() => _instance;
  Notifications._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize the plugin
  Future<void> initNotification() async {
    if (_isInitialized) return; // Already initialized

    // Initialize Android settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/app_icon');

    // Initialize iOS settings
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
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
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily task reminders',
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
}
