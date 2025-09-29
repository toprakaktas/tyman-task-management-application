import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/widgets/task_card.dart';

class UpcomingTasksPage extends ConsumerWidget {
  const UpcomingTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksForTodayProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Upcoming Tasks',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: tasks.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No tasks for today!'));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) => TaskCard(task: data[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            )));
  }
}
