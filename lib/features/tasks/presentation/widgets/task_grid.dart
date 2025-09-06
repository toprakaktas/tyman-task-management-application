import 'package:flutter/material.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/domain/usecases/task/delete_task.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_by_category_and_date.dart';
import 'package:tyman/domain/usecases/task/update_task.dart';
import 'package:tyman/features/tasks/presentation/task_detail_page.dart';

class TaskGrid extends StatelessWidget {
  final List<TaskModel> taskCategories;

  const TaskGrid({super.key, required this.taskCategories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: taskCategories.length,
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        final task = taskCategories[index];
        return _buildTaskCard(context, task);
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TaskDetailPage(
              categoryFilter: task.title,
              fetchTasks: FetchTasksByCategoryAndDate(TaskService()),
              updateTask: UpdateTask(TaskService()),
              deleteTask: DeleteTask(TaskService())),
        ));
      },
      child: Card(
        elevation: 3.0, // Shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: task.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                task.iconData,
                color: task.iconColor,
                size: 35,
              ),
              const SizedBox(height: 10),
              FittedBox(
                child: Text(
                  task.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _buildStatusChip(
                    task.btnColor,
                    task.iconColor,
                    '${task.left} left',
                  ),
                  const SizedBox(width: 5),
                  _buildStatusChip(
                    Colors.white,
                    task.iconColor,
                    '${task.done} done',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color bgColor, Color txtColor, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: txtColor),
      ),
    );
  }
}
