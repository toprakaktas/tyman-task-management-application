import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTasksStream {
  final TaskRepository repository;

  FetchTasksStream(this.repository);

  Stream<List<TaskData>> call(String category, DateTime date) {
    return repository.fetchTasksStream(category, date);
  }
}
