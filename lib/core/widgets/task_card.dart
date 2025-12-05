import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskData task;
  final bool interactive;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onMarkDone;

  const TaskCard(
      {super.key,
      required this.task,
      this.interactive = false,
      this.onEdit,
      this.onDelete,
      this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    final taskModel = TaskModel.fromTitle(task.category);
    final screenWidth = MediaQuery.of(context).size.width;
    final marginH = screenWidth * 0.035;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(
          key: ValueKey(task.id),
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              closeOnCancel: true,
              onDismissed: () {
                return;
              },
              confirmDismiss: () async {
                if (onMarkDone != null) onMarkDone!();

                return false;
              },
            ),
            children: [
              CustomSlidableAction(
                autoClose: true,
                backgroundColor: completeTaskColor,
                onPressed: ((context) {}),
                child: Icon(Icons.check_rounded, size: 25),
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              closeOnCancel: true,
              onDismissed: () {
                return;
              },
              confirmDismiss: () async {
                if (onDelete != null) await onDelete!();

                return false;
              },
            ),
            children: [
              CustomSlidableAction(
                autoClose: true,
                onPressed: ((context) {
                  onDelete?.call();
                }),
                backgroundColor: deleteTaskColor,
                child: Icon(
                  Icons.delete_rounded,
                  size: 25,
                ),
              ),
            ],
          ),
          child: Material(
            color: taskModel.btnColor,
            child: InkWell(
              splashColor: taskModel.iconColor,
              highlightColor: taskModel.iconColor,
              onTap: () {
                if (onEdit != null) onEdit!();
              },
              child: Container(
                color: Colors.transparent,
                child: ListTile(
                  horizontalTitleGap:
                      ListTileTheme.of(context).horizontalTitleGap,
                  minVerticalPadding: 0,
                  minTileHeight: marginH,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: marginH, vertical: marginH),
                  title: Text(
                    task.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                  trailing:
                      Icon(Icons.chevron_right, color: taskModel.iconColor),
                ),
              ),
            ),
          )),
    );
  }
}
