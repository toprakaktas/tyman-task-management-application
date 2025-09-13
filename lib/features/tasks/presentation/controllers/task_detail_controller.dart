import 'package:tyman/core/constants/task_filters.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/usecases/task/delete_task.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_by_category_and_date.dart';
import 'package:tyman/domain/usecases/task/update_task.dart';

class TaskDetailController {
  final String category;
  final FetchTasksByCategoryAndDate fetchTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskDetailController({
    required this.category,
    required this.fetchTask,
    required this.updateTask,
    required this.deleteTask,
  });

  DateTime selectedDate = DateTime.now();
  TaskFilter selectedFilter = TaskFilter.orderBy;

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

  void updateDate(DateTime date) {
    selectedDate = date;
  }

  void updateFilter(TaskFilter filter) {
    selectedFilter = filter;
  }

  Future<void> editTask(TaskData task) async {
    await updateTask(task);
  }

  Future<void> deleteTaskById(String id) async {
    await deleteTask(id);
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
    return updatedTask;
  }
}
