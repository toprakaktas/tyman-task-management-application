import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<bool> call(TaskData task) async {
    return await repository.addTask(task);
  }
}
