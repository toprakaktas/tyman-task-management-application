import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';

Future<bool?> deleteTaskDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(16),
              title: const Row(
                children: [
                  Icon(CupertinoIcons.trash),
                  SizedBox(width: 10),
                  Text('Delete Task', style: TextStyle(color: deleteTaskColor)),
                ],
              ),
              content: const Text(
                'Are you sure you want to delete this task?',
                textAlign: TextAlign.center,
              ),
              contentPadding: EdgeInsets.all(16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete',
                        style: TextStyle(color: deleteTaskColor, fontSize: 16)))
              ]));
}
