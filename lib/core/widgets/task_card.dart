import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';

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
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final marginH = screenWidth * 0.04;
    final marginV = marginH / 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: ClipRRect(
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
              color: theme.cardColor,
              child: InkWell(
                splashColor: theme.colorScheme.tertiary,
                highlightColor: theme.colorScheme.primary,
                onTap: () {
                  if (onEdit != null) onEdit!();
                },
                child: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: marginH, vertical: marginV),
                    title: Text(
                      task.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge!.color,
                        fontSize: theme.textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                    trailing:
                        Icon(Icons.chevron_right, color: theme.iconTheme.color),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
