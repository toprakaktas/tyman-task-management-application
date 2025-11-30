import 'package:flutter/material.dart';
import 'package:tyman/core/constants/task_filters.dart';

class TaskTitle extends StatelessWidget {
  final TaskFilter selectedFilter;
  final Function(TaskFilter) onFilterSelected;

  const TaskTitle(
      {super.key,
      required this.onFilterSelected,
      required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tasks',
            style: TextStyle(
                fontSize: 22,
                color: theme.textTheme.bodyMedium?.color,
                fontWeight: theme.textTheme.bodyLarge?.fontWeight),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: theme.colorScheme.tertiary,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter),
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25)),
            child: PopupMenuButton<TaskFilter>(
              padding: EdgeInsets.zero,
              enableFeedback: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onSelected: onFilterSelected,
              itemBuilder: (context) => <PopupMenuEntry<TaskFilter>>[
                PopupMenuItem<TaskFilter>(
                  value: TaskFilter.time,
                  child: Text(TaskFilter.time.label,
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: theme.textTheme.bodyMedium?.fontWeight)),
                ),
                PopupMenuItem<TaskFilter>(
                  value: TaskFilter.description,
                  child: Text(TaskFilter.description.label,
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: theme.textTheme.bodyMedium?.fontWeight)),
                ),
              ],
              child: Row(
                children: [
                  Text(selectedFilter.label,
                      style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontWeight: theme.textTheme.bodyLarge?.fontWeight,
                          fontSize: 16)),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
