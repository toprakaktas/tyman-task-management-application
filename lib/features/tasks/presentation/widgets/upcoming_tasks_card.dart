import 'package:flutter/material.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/domain/usecases/task/fetch_tasks_for_today.dart';
import 'package:tyman/features/tasks/presentation/upcoming_tasks_page.dart';

class UpcomingTasksCard extends StatelessWidget {
  const UpcomingTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UpcomingTasksPage(
                      fetchTasksForToday: FetchTasksForToday(TaskService()),
                    )));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey[800], shape: BoxShape.circle),
                    child: const Icon(Icons.timelapse,
                        color: Colors.white, size: 25)),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upcoming Tasks',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Check your tasks before deadline!',
                      style: TextStyle(
                        fontSize: 14.75,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 27,
            right: 10,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
