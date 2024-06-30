// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TaskTitle extends StatefulWidget {
  final Function(String) onFilterSelected;

  const TaskTitle({super.key, required this.onFilterSelected});

  @override
  TaskTitleState createState() => TaskTitleState();
}

class TaskTitleState extends State<TaskTitle> {
  String selectedFilter = 'Order By';

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
                color: Colors.grey.withOpacity(0.30),
                borderRadius: BorderRadius.circular(25)),
            child: PopupMenuButton<String>(
              onSelected: (String value) {
                if (mounted) {
                  setState(() {
                    selectedFilter = value;
                  });
                }
                widget.onFilterSelected(value);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Deadline',
                  child: Text('Deadline'),
                ),
                const PopupMenuItem<String>(
                  value: 'Description',
                  child: Text('Description'),
                ),
              ],
              child: Row(
                children: [
                  Text(
                    selectedFilter,
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
