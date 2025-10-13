import 'package:flutter_riverpod/legacy.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/core/constants/task_filters.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/usecases/task/delete_task.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_future.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_stream.dart';
import 'package:tyman/domain/usecases/task/update_task.dart';
import 'package:tyman/features/tasks/presentation/controllers/task_category_state.dart';

class TaskCategoryController extends StateNotifier<TaskCategoryState> {
  final String category;
  final FetchTasksFuture fetchTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final FetchTasksStream? fetchTasksStream;

  TaskCategoryController(
      {required this.category,
      required this.fetchTask,
      required this.updateTask,
      required this.deleteTask,
      this.fetchTasksStream})
      : super(TaskCategoryState(
            selectedDate: DateTime.now(), selectedFilter: TaskFilter.orderBy));

  DateTime get selectedDate => state.selectedDate;
  TaskFilter get selectedFilter => state.selectedFilter;
  bool get hasChanges => state.hasChanges;
  CalendarFormat get calendarFormat => state.calendarFormat;

  Future<List<TaskData>> loadTasks() async {
    final tasks = await fetchTask(category, selectedDate);
    return _sortTasks(tasks);
  }

  List<TaskData> _sortTasks(List<TaskData> tasks) {
    switch (selectedFilter) {
      case TaskFilter.time:
        tasks.sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
        break;
      case TaskFilter.description:
        tasks.sort((a, b) => a.description.compareTo(b.description));
        break;

      /// No sorting needed
      case TaskFilter.orderBy:
        break;
    }
    return tasks;
  }

  Stream<List<TaskData>> getTasksStream(
      DateTime selectedDate, TaskFilter selectedFilter) {
    if (fetchTasksStream != null) {
      return fetchTasksStream!(category, selectedDate)
          .map((tasks) => _sortTasks(List.from(tasks)));
    }
    return Stream.fromFuture(fetchTask(category, state.selectedDate)
        .then((tasks) => _sortTasks(List.from(tasks))));
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateFilter(TaskFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void updateFormat(CalendarFormat format) {
    state = state.copyWith(calendarFormat: format);
  }

  void _markHasChanges() {
    state = state.copyWith(hasChanges: true);
  }

  Future<void> editTask(TaskData task) async {
    await updateTask(task);
    _markHasChanges();
  }

  Future<void> deleteTaskById(String id) async {
    await deleteTask(id);
    _markHasChanges();
  }

  Future<TaskData> toggleCompletion(TaskData task) async {
    final updatedTask = TaskData(
      id: task.id,
      category: task.category,
      description: task.description,
      dueDateTime: task.dueDateTime,
      completed: !task.completed,
    );
    await updateTask(updatedTask);
    _markHasChanges();
    return updatedTask;
  }
}
