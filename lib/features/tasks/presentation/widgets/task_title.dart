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
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(25)),
            child: PopupMenuButton<TaskFilter>(
              onSelected: onFilterSelected,
              itemBuilder: (context) => <PopupMenuEntry<TaskFilter>>[
                PopupMenuItem<TaskFilter>(
                  value: TaskFilter.time,
                  child: Text(TaskFilter.time.label),
                ),
                PopupMenuItem<TaskFilter>(
                  value: TaskFilter.description,
                  child: Text(TaskFilter.description.label),
                ),
              ],
              child: Row(
                children: [
                  Text(
                    selectedFilter.label,
                    style: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.bold),
                  ),
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
