import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/widgets/task_card.dart';

class UpcomingTasksPage extends ConsumerWidget {
  const UpcomingTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksForTodayProvider);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Upcoming Tasks',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge!.color),
          ),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              context.go('/home');
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: tasks.when(
              data: (data) {
                if (data.isEmpty) {
                  return Animate(
                      child: Center(
                          child: Text('No tasks for today!',
                                  style: TextStyle(
                                      fontSize:
                                          theme.textTheme.bodyLarge!.fontSize,
                                      fontWeight:
                                          theme.textTheme.bodyLarge!.fontWeight,
                                      color: theme.textTheme.bodyLarge!.color))
                              .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true))
                              .shake(
                                  rotation: 0.2,
                                  duration: 1.seconds,
                                  hz: 2,
                                  curve: Curves.easeInOutCirc,
                                  delay: 1.seconds)));
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
