import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTaskCounts {
  final TaskRepository repository;

  FetchTaskCounts(this.repository);

  Stream<List<TaskModel>> call() {
    return repository.fetchTaskCounts();
  }
}
