import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tyman/core/widgets/task_card.dart';
import 'package:tyman/data/models/task_data.dart';

class TaskTimelineItem extends StatelessWidget {
  final TaskData task;
  final bool isFirst;
  final bool isLast;
  final Color categoryColor;
  final VoidCallback onEdit;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onMarkDone;

  const TaskTimelineItem({
    super.key,
    required this.task,
    required this.isFirst,
    required this.isLast,
    required this.categoryColor,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final String timeString = DateFormat('HH:mm').format(task.dueDateTime);
    final bool isCompleted = task.completed;
    final theme = Theme.of(context);

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.15,
      isFirst: isFirst,
      isLast: isLast,
      startChild: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeString,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.grey : Colors.black87,
              ),
            ),
          ],
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted
            ? categoryColor.withValues(alpha: 0.4)
            : Colors.grey.shade300,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted
            ? categoryColor.withValues(alpha: 0.4)
            : Colors.grey.shade300,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        width: 28,
        height: 28,
        padding: EdgeInsets.zero,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted ? categoryColor : theme.scaffoldBackgroundColor,
            border: Border.all(
              color: isCompleted
                  ? categoryColor
                  : categoryColor.withValues(alpha: 0.4),
              width: 1,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              if (!isCompleted)
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
      ),
      endChild: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Opacity(
          opacity: isCompleted ? 0.5 : 1.0,
          child: TaskCard(
            task: task,
            interactive: true,
            onEdit: onEdit,
            onDelete: onDelete,
            onMarkDone: onMarkDone,
          ),
        ),
      ),
    );
  }
}
