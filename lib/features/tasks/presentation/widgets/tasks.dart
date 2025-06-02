import 'package:flutter/material.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/features/tasks/presentation/detail.dart';

class Tasks extends StatefulWidget {
  final List<TaskModel> taskCategories;
  const Tasks({super.key, required this.taskCategories});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.taskCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        final task = widget.taskCategories[index];
        return buildTask(context, task);
      },
    );
  }

  Widget buildTask(BuildContext context, TaskModel task) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        categoryFilter: task.title,
                      )),
            )
            .then((_) => setState(() {}));
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
                  buildTaskStatus(
                    task.btnColor,
                    task.iconColor,
                    '${task.left} left',
                  ),
                  const SizedBox(width: 5),
                  buildTaskStatus(
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

  Widget buildTaskStatus(Color bgColor, Color txtColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: txtColor),
      ),
    );
  }
}
