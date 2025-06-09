import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTaskCountsForCategories {
  final TaskRepository repository;

  FetchTaskCountsForCategories(this.repository);

  Future<List<TaskModel>> call() async {
    return await repository.fetchTaskCountsForCategories();
  }
}
