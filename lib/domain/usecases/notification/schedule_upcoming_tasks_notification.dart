import 'package:tyman/domain/services/notification_repository.dart';

class ScheduleUpcomingTasksNotification {
  final NotificationRepository repository;

  ScheduleUpcomingTasksNotification(this.repository);

  Future<void> call({
    required int taskCount,
    int id = 2,
    int hour = 9,
    int minute = 0,
  }) async {
    await repository.scheduleUpcomingTasksNotification(
      taskCount: taskCount,
      id: id,
      hour: hour,
      minute: minute,
    );
  }
}
