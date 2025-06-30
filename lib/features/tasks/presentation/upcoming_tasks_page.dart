import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tyman/core/widgets/task_card.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_for_today.dart';

class UpcomingTasksPage extends StatefulWidget {
  final FetchTasksForToday fetchTasksForToday;

  const UpcomingTasksPage({super.key, required this.fetchTasksForToday});

  @override
  State<UpcomingTasksPage> createState() => _UpcomingTasksPageState();
}

class _UpcomingTasksPageState extends State<UpcomingTasksPage> {
  late Future<List<TaskData>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = widget.fetchTasksForToday();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: FutureBuilder<List<TaskData>>(
          future: tasksFuture,
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
              itemBuilder: (_, index) {
                final task = snapshot.data![index];
                return TaskCard(task: task);
              },
            );
          },
        ),
      ),
    );
  }
}
