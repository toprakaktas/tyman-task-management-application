import 'package:flutter/material.dart';

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

    return SliverAppBar(
      pinned: true,
      expandedHeight: 90,
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(true),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        iconSize: 20,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category tasks',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(
              todayTaskText,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
