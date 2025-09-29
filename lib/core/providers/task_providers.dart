import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/domain/usecases/task/add_task.dart';
import 'package:tyman/domain/usecases/task/delete_task.dart';
import 'package:tyman/domain/usecases/task/fetch_task_counts_for_categories.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_by_category_and_date.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_for_today.dart';
import 'package:tyman/domain/usecases/task/update_task.dart';
import 'package:tyman/features/tasks/presentation/controllers/task_detail_controller.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final addTaskProvider =
    Provider<AddTask>((ref) => AddTask(ref.watch(taskServiceProvider)));

final fetchTaskCountsForCategoriesProvider =
    Provider<FetchTaskCountsForCategories>(
        (ref) => FetchTaskCountsForCategories(ref.watch(taskServiceProvider)));

final fetchTasksByCategoryAndDateProvider =
    Provider<FetchTasksByCategoryAndDate>(
        (ref) => FetchTasksByCategoryAndDate(ref.watch(taskServiceProvider)));

final updateTaskProvider =
    Provider<UpdateTask>((ref) => UpdateTask(ref.watch(taskServiceProvider)));

final deleteTaskProvider =
    Provider<DeleteTask>((ref) => DeleteTask(ref.watch(taskServiceProvider)));

final fetchTasksForTodayProvider = Provider<FetchTasksForToday>(
    (ref) => FetchTasksForToday(ref.watch(taskServiceProvider)));

final taskCountsProvider = FutureProvider<List<TaskModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.hasError) throw authState.error!;
  final user = authState.maybeWhen(data: (user) => user, orElse: () => null);
  if (user == null) {
    return <TaskModel>[];
  }
  final fetchTaskCounts = ref.watch(fetchTaskCountsForCategoriesProvider);
  return fetchTaskCounts();
});

final tasksForTodayProvider = FutureProvider<List<TaskData>>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.hasError) throw authState.error!;
  final user = authState.maybeWhen(data: (user) => user, orElse: () => null);
  if (user == null) {
    return <TaskData>[];
  }
  return ref.watch(fetchTasksForTodayProvider)();
});

final taskDetailControllerProvider =
    Provider.family<TaskDetailController, String>((ref, category) {
  return TaskDetailController(
      category: category,
      fetchTask: ref.read(fetchTasksByCategoryAndDateProvider),
      updateTask: ref.read(updateTaskProvider),
      deleteTask: ref.read(deleteTaskProvider));
});
