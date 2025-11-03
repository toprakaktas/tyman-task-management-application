import 'package:tyman/domain/services/notification_repository.dart';
import 'package:tyman/core/notifications/notifications.dart';

class NotificationService implements NotificationRepository {
  final Notifications _notification = Notifications();

  @override
  Future<void> scheduleUpcomingTasksNotification(
      {required int taskCount, int id = 2, int hour = 9, int minute = 0}) {
    return _notification.scheduleUpcomingTasksNotification(
        taskCount: taskCount, id: id, hour: hour, minute: minute);
  }

  @override
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    return _notification.scheduleNotification(
      id: id,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
    );
  }

  @override
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return _notification.showNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  @override
  Future<void> cancelNotification(int id) {
    return _notification.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotifications() {
    return _notification.cancelAllNotifications();
  }
}
