import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/widgets/app_alert_dialog.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/features/tasks/presentation/widgets/date_picker.dart';
import 'package:tyman/features/tasks/presentation/widgets/delete_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/detail_sliver_app_bar.dart';
import 'package:tyman/features/tasks/presentation/widgets/edit_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/task_timeline_item.dart';
import 'package:tyman/features/tasks/presentation/widgets/task_title.dart';

class TaskCategoryPage extends ConsumerStatefulWidget {
  final String categoryFilter;

  const TaskCategoryPage({
    super.key,
    required this.categoryFilter,
  });

  @override
  ConsumerState<TaskCategoryPage> createState() => _TaskCategoryPageState();
}

class _TaskCategoryPageState extends ConsumerState<TaskCategoryPage> {
  Future<void> _editTask(TaskData task) async {
    final editedTask = await showDialog<TaskData>(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );

    if (editedTask != null) {
      final controller = ref
          .read(taskCategoryControllerProvider(widget.categoryFilter).notifier);
      try {
        await controller.editTask(editedTask);
        if (mounted) showSuccess(context, 'Task updated successfully!');
      } catch (e) {
        if (mounted) showError(context, 'Failed to update task');
      }
    }
  }

  Future<void> _deleteTask(TaskData task) async {
    final confirm = await deleteTaskDialog(context);

    if (confirm == true) {
      final controller = ref
          .read(taskCategoryControllerProvider(widget.categoryFilter).notifier);
      try {
        await controller.deleteTaskById(task.id);
        if (mounted) showSuccess(context, 'Task deleted successfully!');
      } catch (e) {
        if (mounted) showError(context, 'Failed to delete task');
      }
    }
  }

  Future<void> _markTaskAsDone(TaskData task) async {
    final controller = ref
        .read(taskCategoryControllerProvider(widget.categoryFilter).notifier);
    try {
      final updated = await controller.toggleCompletion(task);
      if (mounted) {
        final message = updated.completed
            ? 'Well done! You have completed the task!'
            : 'Task marked as not completed.';
        showSuccess(context, message);
      }
    } catch (e) {
      if (mounted) showError(context, 'Failed to mark task as done');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState =
        ref.watch(taskCategoryControllerProvider(widget.categoryFilter));
    final controller = ref
        .read(taskCategoryControllerProvider(widget.categoryFilter).notifier);
    final asyncTasks =
        ref.watch(taskCategoryStreamProvider(widget.categoryFilter));

    final theme = Theme.of(context);
    final taskModel = TaskModel.fromTitle(widget.categoryFilter);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: asyncTasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (tasks) {
          final taskLeft = tasks.where((task) => !task.completed).length;
          final slivers = <Widget>[
            DetailSliverAppBar(
                category: widget.categoryFilter, taskLeft: taskLeft),
            SliverToBoxAdapter(
              child: ColoredBox(
                color: taskModel.btnColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      DatePicker(
                        selectedDate: controllerState.selectedDate,
                        calendarFormat: controller.calendarFormat,
                        onFormatChanged: (format) =>
                            controller.updateFormat(format),
                        onDateChanged: (date) => controller.updateDate(date),
                        category: widget.categoryFilter,
                      ),
                      TaskTitle(
                          onFilterSelected: (filter) =>
                              controller.updateFilter(filter),
                          selectedFilter: controller.selectedFilter),
                    ],
                  ),
                ),
              ),
            ),
          ];

          if (tasks.isEmpty) {
            slivers.add(
              SliverFillRemaining(
                child: Container(
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: Text('There are no tasks for today.',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface, fontSize: 18)),
                  ),
                ),
              ),
            );
          } else {
            slivers.add(
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final task = tasks[index];

                    final isFirst = index == 0;
                    final isLast = index == tasks.length - 1;

                    return TaskTimelineItem(
                      task: task,
                      isFirst: isFirst,
                      isLast: isLast,
                      categoryColor: taskModel.iconColor,
                      onEdit: () => _editTask(task),
                      onDelete: () => _deleteTask(task),
                      onMarkDone: () => _markTaskAsDone(task),
                    );
                  },
                  childCount: tasks.length,
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: slivers,
          );
        },
      ),
    );
  }
}
