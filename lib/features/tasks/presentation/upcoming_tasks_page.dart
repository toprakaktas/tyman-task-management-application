import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/features/tasks/presentation/widgets/smart_schedule_view.dart';

class UpcomingTasksPage extends ConsumerWidget {
  const UpcomingTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksForTodayProvider);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Daily Schedule',
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: tasks.when(
            data: (data) {
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'No tasks for today!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge!.color,
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).shake(
                          duration: 1.seconds,
                          hz: 2,
                          curve: Curves.easeInOutCirc),
                      Text("Enjoy your free time! ☕",
                          style: TextStyle(color: theme.shadowColor)),
                    ],
                  ),
                );
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SmartScheduleView(tasks: data),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ));
  }
}
