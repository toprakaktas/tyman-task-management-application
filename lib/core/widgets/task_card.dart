import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskData task;
  final bool interactive;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkDone;

  const TaskCard(
      {super.key,
      required this.task,
      this.interactive = false,
      this.onEdit,
      this.onDelete,
      this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    final TaskModel model = TaskModel.fromTitle(task.category);

    final screenWidth = MediaQuery.of(context).size.width;
    final marginH = screenWidth * 0.04;
    final marginV = marginH / 4;

    Color cardColor() {
      if (task.completed == true && interactive) {
        return markedTaskColor;
      } else if (task.completed == false && !interactive) {
        return model.bgColor;
      } else if (task.completed == true && interactive) {
        return Colors.grey.shade200;
      } else {
        return CupertinoColors.systemGrey5;
      }
    }

//TODO: interactive & completed bg colors needs fix
    return Card(
        elevation: 0.75,
        margin:
            EdgeInsets.symmetric(horizontal: marginH * 0.15, vertical: marginV),
        color: cardColor.call(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
          leading: interactive
              ? IconButton(
                  icon: Icon(
                    task.completed
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.circle,
                    color: completeTaskColor,
                  ),
                  onPressed: onMarkDone)
              : Icon(model.iconData, color: model.iconColor, size: 28),
          title: Text(
            task.description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: task.completed ? Colors.grey.shade600 : Colors.black,
              fontSize: 16.5,
            ),
          ),
          subtitle: Text(
            '${task.category} • ${DateFormat('dd/MM').format(task.dueDateTime)} • '
            '${task.dueDateTime.hour.toString().padLeft(2, '0')}:'
            '${task.dueDateTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: task.completed ? Colors.grey.shade600 : Colors.black,
              fontSize: 14,
            ),
          ),
          trailing: interactive
              ? Wrap(spacing: 3, children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.pen),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.trash,
                      color: deleteTaskColor,
                    ),
                    onPressed: onDelete,
                  ),
                ])
              : Icon(
                  task.completed
                      ? Icons.check_circle
                      : Icons.schedule, // or CupertinoIcons
                  color: task.completed ? Colors.green : Colors.redAccent,
                ),
        ));
  }
}
