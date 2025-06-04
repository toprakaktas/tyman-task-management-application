import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/services/task_service.dart';

class UpcomingTasksPage extends StatefulWidget {
  const UpcomingTasksPage({super.key});

  @override
  UpcomingTasksPageState createState() => UpcomingTasksPageState();
}

class UpcomingTasksPageState extends State<UpcomingTasksPage> {
  late Future<List<TaskData>> _tasksForToday;

  @override
  void initState() {
    super.initState();
    _tasksForToday = TaskService().fetchTasksForToday();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<TaskData>>(
        future: _tasksForToday,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks for today!'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              final TaskModel taskModel = TaskModel.fromTitle(task.category);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: taskModel.bgColor,
                child: ListTile(
                  leading: Icon(
                    task.category == taskModel.title
                        ? taskModel.iconData
                        : Icons.error,
                    color: taskModel.iconColor,
                  ),
                  title: Text(
                    task.description,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: task.completed
                            ? Colors.grey.shade600
                            : Colors.black,
                        fontSize: 17),
                  ),
                  subtitle: Text(
                    '${task.category} • ${DateFormat('dd/MM/yy').format(task.dueDateTime)} • ${task.dueDateTime.hour}:${task.dueDateTime.minute}',
                    style: TextStyle(
                      color:
                          task.completed ? Colors.grey.shade600 : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    task.completed
                        ? CupertinoIcons.checkmark_circle
                        : CupertinoIcons.time,
                    color: task.completed
                        ? CupertinoColors.activeGreen
                        : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
