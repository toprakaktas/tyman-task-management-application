import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> deleteTaskDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(CupertinoIcons.trash),
                  SizedBox(width: 10),
                  Text('Delete Task',
                      style: TextStyle(color: CupertinoColors.destructiveRed)),
                ],
              ),
              content: const Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete',
                        style: TextStyle(
                            color: CupertinoColors.destructiveRed,
                            fontSize: 13)))
              ]));
}
