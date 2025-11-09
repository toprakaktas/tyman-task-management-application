import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';

class TaskModel {
  final IconData iconData;
  final String title;
  final Color bgColor;
  final Color iconColor;
  final Color btnColor;
  int left;
  int done;

  TaskModel({
    required this.iconData,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.btnColor,
    this.left = 0,
    this.done = 0,
  });

  TaskModel.personal()
      : this(
            title: 'Personal',
            iconData: Icons.person,
            bgColor: cardYellowLight,
            iconColor: cardYellowDark,
            btnColor: cardYellow);

  TaskModel.work()
      : this(
            title: 'Work',
            iconData: Icons.cases_rounded,
            bgColor: cardBlueLight,
            iconColor: cardBlueDark,
            btnColor: cardBlue);

  TaskModel.health()
      : this(
            title: 'Health',
            iconData: Icons.favorite_rounded,
            bgColor: cardRedLight,
            iconColor: kRedDark,
            btnColor: cardRed);

  TaskModel.other()
      : this(
            title: 'Other',
            iconData: Icons.app_registration_rounded,
            bgColor: Colors.grey,
            iconColor: designGrey,
            btnColor: designGreyLight);

  static TaskModel fromTitle(String title) {
    switch (title) {
      case 'Personal':
        return TaskModel.personal();
      case 'Work':
        return TaskModel.work();
      case 'Health':
        return TaskModel.health();
      case 'Other':
        return TaskModel.other();
      default:
        return TaskModel.other();
    }
  }
}
