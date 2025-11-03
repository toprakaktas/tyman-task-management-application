abstract class NotificationRepository {
  Future<void> scheduleUpcomingTasksNotification({
    required int taskCount,
    int id = 2,
    int hour = 9,
    int minute = 0,
  });

  Future<void> scheduleNotification(
      {int id = 1,
      required String title,
      required String body,
      required int hour,
      required int minute});

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  });

  Future<void> cancelNotification(int id);

  Future<void> cancelAllNotifications();
}
