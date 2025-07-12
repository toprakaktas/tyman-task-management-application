import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';

class TaskCardStyle {
  final TaskData task;
  final TaskModel model;
  final bool interactive;

  const TaskCardStyle({
    required this.task,
    required this.model,
    required this.interactive,
  });

  Color get backgroundColor {
    if (interactive && task.completed) return markedTaskColor;
    if (interactive && !task.completed) return detailTaskBGColor;
    if (!interactive && task.completed) return model.bgColor;
    return model.btnColor;
  }

  Color get titleColor =>
      task.completed ? Colors.grey.shade600 : Colors.black87;

  Color get subtitleColor =>
      task.completed ? Colors.grey.shade600 : Colors.black;

  IconData get statusIcon =>
      task.completed ? Icons.check_circle : Icons.schedule;

  Color get statusIconColor =>
      task.completed ? upcomingIconColorActive : upcomingIconColorInactive;

  IconData get toggleIcon => task.completed
      ? CupertinoIcons.check_mark_circled_solid
      : CupertinoIcons.circle;
}
