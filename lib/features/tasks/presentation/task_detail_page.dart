import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/core/constants/task_filters.dart';
import 'package:tyman/core/providers/task_providers.dart';
import 'package:tyman/core/widgets/app_alert_dialog.dart';
import 'package:tyman/core/widgets/task_card.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/features/tasks/presentation/controllers/task_detail_controller.dart';
import 'package:tyman/features/tasks/presentation/widgets/date_picker.dart';
import 'package:tyman/features/tasks/presentation/widgets/delete_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/detail_sliver_app_bar.dart';
import 'package:tyman/features/tasks/presentation/widgets/edit_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/task_title.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final String categoryFilter;

  const TaskDetailPage({
    super.key,
    required this.categoryFilter,
  });

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  late TaskDetailController controller;
  late Future<List<TaskData>> tasksFuture;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    controller = ref.read(taskDetailControllerProvider(widget.categoryFilter));
    tasksFuture = controller.loadTasks();
  }

  void onDateSelected(DateTime newDate) {
    if (!isSameDay(controller.selectedDate, newDate)) {
      controller.updateDate(newDate);
      if (mounted) {
        tasksFuture = controller.loadTasks();
        setState(() {});
      }
    }
  }

  void onFilterSelected(TaskFilter filter) {
    controller.updateFilter(filter);
    if (mounted) {
      tasksFuture = controller.loadTasks();
      setState(() {});
    }
  }

  Future<void> editTask(TaskData task) async {
    final editedTask = await showDialog<TaskData>(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );

    if (editedTask != null) {
      try {
        await controller.editTask(editedTask);
      } catch (e) {
        if (mounted) showError(context, 'Failed to update task');
        return;
      }
      tasksFuture = controller.loadTasks();
      setState(() {});
      hasChanges = true;
      if (mounted) showSuccess(context, 'Task updated successfully!');
    }
  }

  Future<void> deleteTask(TaskData task) async {
    final confirm = await deleteTaskDialog(context);

    if (confirm == true) {
      try {
        await controller.deleteTaskById(task.id);
      } catch (e) {
        if (mounted) showError(context, 'Failed to delete task');
        return;
      }
      tasksFuture = controller.loadTasks();
      setState(() {});
      hasChanges = true;
      if (mounted) showSuccess(context, 'Task deleted successfully!');
    }
  }

  Future<void> markTaskAsDone(TaskData task) async {
    TaskData updatedTask;

    try {
      updatedTask = await controller.toggleCompletion(task);
    } catch (e) {
      if (mounted) showError(context, 'Failed to mark task as done');
      return;
    }
    tasksFuture = controller.loadTasks();
    setState(() {});
    hasChanges = true;
    final message = updatedTask.completed
        ? 'Well done! You have completed the task!'
        : 'Task marked as not completed.';
    if (mounted) showSuccess(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(hasChanges);
        return false;
      },
      child: Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<TaskData>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          int taskLeft = 0;
          if (snapshot.hasData && snapshot.data != null) {
            taskLeft =
                snapshot.data!.where((task) => task.completed == false).length;
          }
          List<Widget> slivers = [
            DetailSliverAppBar(
                category: widget.categoryFilter, taskLeft: taskLeft),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    DatePicker(onDateChanged: onDateSelected),
                    TaskTitle(
                        onFilterSelected: onFilterSelected,
                        selectedFilter: controller.selectedFilter),
                  ],
                ),
              ),
            ),
          ];

          if (snapshot.connectionState == ConnectionState.waiting) {
            slivers.add(
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            slivers.add(
              SliverFillRemaining(
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text('There are no tasks for today.',
                        style: TextStyle(color: Colors.grey, fontSize: 18)),
                  ),
                ),
              ),
            );
          } else {
            slivers.add(
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    TaskData task = snapshot.data![index];
                    return TaskCard(
                      task: task,
                      interactive: true,
                      onEdit: () => editTask(task),
                      onDelete: () => deleteTask(task),
                      onMarkDone: () => markTaskAsDone(task),
                    );
                  },
                  childCount: snapshot.data!.length,
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: slivers,
          );
        },
      ),
    ),
    );
  }
}
