import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/data/services/notification_service.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/domain/services/notification_repository.dart';
import 'package:tyman/domain/usecases/notification/schedule_upcoming_tasks_notification.dart';
import 'package:tyman/domain/usecases/task/add_task.dart';
import 'package:tyman/domain/usecases/task/delete_task.dart';
import 'package:tyman/domain/usecases/task/fetch_task_counts.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_future.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_for_today.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_stream.dart';
import 'package:tyman/domain/usecases/task/update_task.dart';
import 'package:tyman/features/tasks/presentation/controllers/task_category_controller.dart';
import 'package:tyman/features/tasks/presentation/controllers/task_category_state.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final addTaskProvider =
    Provider<AddTask>((ref) => AddTask(ref.watch(taskServiceProvider)));

final fetchTaskCountsForCategoriesProvider = Provider<FetchTaskCounts>(
    (ref) => FetchTaskCounts(ref.watch(taskServiceProvider)));

final fetchTasksFutureProvider = Provider<FetchTasksFuture>(
    (ref) => FetchTasksFuture(ref.watch(taskServiceProvider)));

final fetchTasksStreamProvider = Provider<FetchTasksStream>(
    (ref) => FetchTasksStream(ref.watch(taskServiceProvider)));

final updateTaskProvider =
    Provider<UpdateTask>((ref) => UpdateTask(ref.watch(taskServiceProvider)));

final deleteTaskProvider =
    Provider<DeleteTask>((ref) => DeleteTask(ref.watch(taskServiceProvider)));

final fetchTasksForTodayProvider = Provider<FetchTasksForToday>(
    (ref) => FetchTasksForToday(ref.watch(taskServiceProvider)));

final taskCountsProvider = StreamProvider<List<TaskModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.hasError) Stream.error(authState.error!);
  final user = authState.value;
  if (user == null) {
    return Stream.value(<TaskModel>[]);
  }
  final fetchTaskCounts = ref.watch(fetchTaskCountsForCategoriesProvider);
  return fetchTaskCounts();
});

final tasksForTodayProvider = StreamProvider.autoDispose<List<TaskData>>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.hasError) throw authState.error!;
  final user = authState.maybeWhen(data: (user) => user, orElse: () => null);
  if (user == null) {
    return Stream<List<TaskData>>.value(<TaskData>[]);
  }
  return ref.watch(fetchTasksForTodayProvider)();
});

final taskCategoryControllerProvider = StateNotifierProvider.family
    .autoDispose<TaskCategoryController, TaskCategoryState, String>(
        (ref, category) {
  final fetchTask = ref.watch(fetchTasksFutureProvider);
  final fetchTasksStream = ref.watch(fetchTasksStreamProvider);
  final updateTask = ref.watch(updateTaskProvider);
  final deleteTask = ref.watch(deleteTaskProvider);
  return TaskCategoryController(
      category: category,
      fetchTask: fetchTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
      fetchTasksStream: fetchTasksStream);
});

final taskCategoryStreamProvider =
    StreamProvider.family.autoDispose<List<TaskData>, String>((ref, category) {
  final state = ref.watch(taskCategoryControllerProvider(category));
  final controller =
      ref.read(taskCategoryControllerProvider(category).notifier);
  return controller.getTasksStream(state.selectedDate, state.selectedFilter);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationService();
});

final scheduleUpcomingTasksNotificationProvider =
    Provider<ScheduleUpcomingTasksNotification>((ref) {
  return ScheduleUpcomingTasksNotification(
    ref.watch(notificationRepositoryProvider),
  );
});

final upcomingTasksNotificationProvider = Provider<void>((ref) {
  final scheduleNotification =
      ref.watch(scheduleUpcomingTasksNotificationProvider);

  ref.listen(tasksForTodayProvider, (previous, next) {
    next.whenData((tasks) {
      final incompleteTasks = tasks.where((task) => !task.completed).toList();
      final taskCount = incompleteTasks.length;

      scheduleNotification.call(taskCount: taskCount);
    });
  });
});

final taskNotificationListenerProvider = Provider.autoDispose<void>((ref) {
  final tasksAsync = ref.watch(tasksForTodayProvider);
  final scheduleNotification =
      ref.watch(scheduleUpcomingTasksNotificationProvider);

  tasksAsync.whenData((tasks) {
    final incompleteTasks = tasks.where((task) => !task.completed).length;
    scheduleNotification(
      taskCount: incompleteTasks,
      hour: 9,
      minute: 0,
    );
  });
});
