import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTasksFuture {
  final TaskRepository repository;

  FetchTasksFuture(this.repository);

  Future<List<TaskData>> call(String category, DateTime date) async {
    return await repository.fetchTasksFuture(category, date);
  }
}
