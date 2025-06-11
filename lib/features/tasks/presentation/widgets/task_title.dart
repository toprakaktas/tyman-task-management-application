import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

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
            child: PopupMenuButton<String>(
              onSelected: onFilterSelected,
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
