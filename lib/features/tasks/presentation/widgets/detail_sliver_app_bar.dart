import 'package:flutter/material.dart';
import 'package:tyman/data/models/task_model.dart';

class DetailSliverAppBar extends StatelessWidget {
  final String category;
  final int taskLeft;

  const DetailSliverAppBar(
      {super.key, required this.category, required this.taskLeft});

  @override
  Widget build(BuildContext context) {
    final todayTaskText = taskLeft == 1
        ? '$taskLeft task for today!'
        : '$taskLeft tasks for today!';
    final TaskModel taskModel = TaskModel.fromTitle(category);
    final theme = Theme.of(context);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 90,
      backgroundColor: taskModel.btnColor,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(true),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        iconSize: 20,
        color: taskModel.iconColor,
        enableFeedback: true,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category tasks',
              style: TextStyle(
                  fontWeight: theme.textTheme.bodyLarge?.fontWeight,
                  fontSize: theme.textTheme.bodyLarge?.fontSize,
                  color: taskModel.iconColor.withValues(
                    red: taskModel.iconColor.r + 66,
                    green: taskModel.iconColor.g + 66,
                    blue: taskModel.iconColor.b + 66,
                  )),
            ),
            Text(
              todayTaskText,
              style: TextStyle(
                  fontSize: 12,
                  color: taskModel.iconColor.withValues(
                    red: taskModel.iconColor.r + 66,
                    green: taskModel.iconColor.g + 66,
                    blue: taskModel.iconColor.b + 66,
                  ),
                  fontWeight: theme.textTheme.bodySmall?.fontWeight),
            )
          ],
        ),
      ),
    );
  }
}
