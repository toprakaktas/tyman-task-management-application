import 'package:flutter/material.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/features/tasks/presentation/task_category_page.dart';

class TaskGrid extends StatelessWidget {
  final List<TaskModel> taskCategories;
  final VoidCallback? onChanged;

  const TaskGrid({super.key, required this.taskCategories, this.onChanged});

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
      onTap: () async {
        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TaskCategoryPage(categoryFilter: task.title),
        ));
        if (result == true && onChanged != null) {
          onChanged!();
        }
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
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: task.iconColor.withValues(
                        red: task.iconColor.r + 66,
                        green: task.iconColor.g + 66,
                        blue: task.iconColor.b + 66,
                      )),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(
                    context,
                    task.btnColor,
                    task.iconColor,
                    '${task.left} left',
                  ),
                  _buildStatusChip(
                    context,
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

  Widget _buildStatusChip(
      BuildContext context, Color bgColor, Color txtColor, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(
            color: txtColor, fontSize: theme.textTheme.labelLarge!.fontSize),
      ),
    );
  }
}
