import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';

class SmartScheduleView extends StatelessWidget {
  final List<TaskData> tasks;

  const SmartScheduleView({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: 24,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, hour) {
        final tasksInThisHour =
            tasks.where((t) => t.dueDateTime.hour == hour).toList();

        if (tasksInThisHour.isNotEmpty) {
          tasksInThisHour
              .sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
        }

        final bool hasTask = tasksInThisHour.isNotEmpty;

        /// No task for this hour display
        if (!hasTask) {
          return Row(
            children: [
              SizedBox(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.shadowColor.withValues(alpha: 0.3),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: theme.shadowColor.withValues(alpha: 0.1),
                ),
              ),
            ],
          );
        }

        /// Tasks for this hour display
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Hour Column
              SizedBox(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        color: theme.shadowColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// Tasks Column
              Expanded(
                child: Column(
                  children: tasksInThisHour.map((task) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildScheduleCard(context, task),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard(BuildContext context, TaskData task) {
    final taskModel = TaskModel.fromTitle(task.category);
    final minuteColor = Color.lerp(taskModel.iconColor, Colors.black, 0.3)!;
    final doneColor = Colors.blueGrey.withValues(alpha: 0.3);
    final displayColor = task.completed ? doneColor : minuteColor;
    final descColorDark = Color.lerp(taskModel.iconColor, Colors.white, 0.1)!;
    final textColor = task.completed ? doneColor : descColorDark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.completed
            ? Colors.grey.withValues(alpha: 0.1)
            : taskModel.btnColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: taskModel.btnColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('mm').format(task.dueDateTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: displayColor,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Task Description and Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: textColor,
                      decoration:
                          task.completed ? TextDecoration.lineThrough : null,
                      decorationColor: doneColor),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  task.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: taskModel.iconColor,
                  ),
                ),
              ],
            ),
          ),

          if (task.completed)
            const Icon(Icons.check_circle, color: markedTaskColor, size: 20)
          else
            Icon(Icons.circle_outlined, color: taskModel.iconColor, size: 20),
        ],
      ),
    );
  }
}
