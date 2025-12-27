import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tyman/domain/services/notification_repository.dart';
import 'package:tyman/core/notifications/notifications.dart';

class NotificationService implements NotificationRepository {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final Notifications _notifications = Notifications();

  @override
  Future<void> requestPermission() async {
    await _fcm.requestPermission(
        alert: true, badge: true, sound: true, provisional: false);
  }

  @override
  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  @override
  Stream<String?> get onTokenRefresh => _fcm.onTokenRefresh;

  @override
  Future<void> showLocalNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return _notifications.showNotification(
        id: id, title: title, body: body, payload: payload);
  }
}
