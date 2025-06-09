import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class FetchTasksByCategoryAndDate {
  final TaskRepository repository;

  FetchTasksByCategoryAndDate(this.repository);

  Future<List<TaskData>> call(String category, DateTime date) async {
    return await repository.fetchTasksByCategoryAndDate(category, date);
  }
}
