import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTasksForToday {
  final TaskRepository repository;

  FetchTasksForToday(this.repository);

  Stream<List<TaskData>> call() {
    return repository.fetchTasksForToday();
  }
}
