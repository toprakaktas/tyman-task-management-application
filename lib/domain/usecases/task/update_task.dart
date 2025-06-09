import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/services/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(TaskData task) async {
    await repository.updateTask(task);
  }
}
