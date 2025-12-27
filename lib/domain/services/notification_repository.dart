abstract class NotificationRepository {
  Future<void> requestPermission();

  Future<String?> getToken();

  Stream<String?> get onTokenRefresh;

  Future<void> showLocalNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  });
}
