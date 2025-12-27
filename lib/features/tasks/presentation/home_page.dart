import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/core/providers/user_provider.dart';
import 'package:tyman/core/widgets/app_bottom_nav_bar.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/home_app_bar.dart';
import 'package:tyman/features/tasks/presentation/widgets/task_grid.dart';
import 'package:tyman/features/tasks/presentation/widgets/upcoming_tasks_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fcmSetupProvider);
    final taskCategories = ref.watch(taskCountsProvider);
    final AppUser? appUser = ref.watch(userProfileProvider).value;
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: HomeAppBar(user: appUser),
        body: taskCategories.when(
          data: (tasks) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(taskCountsProvider);
              await ref.read(taskCountsProvider.future);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UpcomingTasksCard(),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                    'Tasks',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: TaskGrid(
                  taskCategories: tasks,
                )),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
        bottomNavigationBar: AppBottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                context.go('/profile');
              }
            }),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
          onPressed: () => showDialog(
              context: context,
              builder: (_) => AddTaskDialog(
                  onAdd: ref.read(addTaskProvider).call,
                  onAdded: () => ref.invalidate(taskCountsProvider))),
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ));
  }
}
