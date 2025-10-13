import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';

abstract class TaskRepository {
  Future<bool> addTask(TaskData task);

  Future<void> deleteTask(String taskId);

  Future<void> updateTask(TaskData task);

  Future<List<TaskData>> fetchTasksFuture(String category, DateTime date);

  Stream<List<TaskData>> fetchTasksStream(String category, DateTime date);

  Future<List<TaskData>> fetchTasksForToday();

  Future<List<TaskModel>> fetchTaskCounts();
}
