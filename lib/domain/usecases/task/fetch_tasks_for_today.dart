import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTasksForToday {
  final TaskRepository repository;

  FetchTasksForToday(this.repository);

  Future<List<TaskData>> call() async {
    return await repository.fetchTasksForToday();
  }
}
