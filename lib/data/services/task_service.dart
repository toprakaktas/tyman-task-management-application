import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/domain/services/task_repository.dart';
import 'package:uuid/uuid.dart';

class TaskService implements TaskRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<bool> addTask(TaskData taskData) async {
    try {
      var uuid = const Uuid().v4();
      taskData.id = uuid;
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .set(taskData.toMap());

      if (kDebugMode) {
        print("Task added with ID: $uuid");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error adding task: $e");
      }
      return false;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
      if (kDebugMode) {
        print("Task successfully deleted!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting task: $e");
      }
    }
  }

  @override
  Future<void> updateTask(TaskData task) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
      if (kDebugMode) {
        print("Task successfully updated!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating task: $e");
      }
    }
  }

  @override
  Future<List<TaskData>> fetchTasksByCategoryAndDate(
      String category, DateTime date) async {
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    if (kDebugMode) {
      print("Querying from $start to $end in category: $category");
    }
    try {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .where('category', isEqualTo: category)
          .where('dueDateTime', isGreaterThanOrEqualTo: start)
          .where('dueDateTime', isLessThanOrEqualTo: end)
          .get();
      List<TaskData> tasks =
          snapshot.docs.map((doc) => TaskData.fromFirestore(doc)).toList();
      return tasks;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Future<List<TaskModel>> fetchTaskCountsForCategories() async {
    DateTime date = DateTime.now();
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    List<TaskModel> taskCategories = [
      TaskModel.personal(),
      TaskModel.work(),
      TaskModel.health(),
      TaskModel.other()
    ];

    for (var taskCategory in taskCategories) {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('tasks')
          .where('category', isEqualTo: taskCategory.title)
          .where('dueDateTime', isGreaterThanOrEqualTo: start)
          .where('dueDateTime', isLessThanOrEqualTo: end)
          .get();

      if (kDebugMode) {
        print('Category: ${taskCategory.title}');
      }
      if (kDebugMode) {
        print('Documents Retrieved: ${snapshot.docs.length}');
      }

      int leftCount = 0;
      int doneCount = 0;

      for (var doc in snapshot.docs) {
        if (kDebugMode) {
          print('Document Data: ${doc.data()}');
        }
        bool completed =
            (doc.data() as Map<String, dynamic>)['completed'] ?? false;
        if (completed == false) {
          leftCount++;
        } else if (completed == true) {
          doneCount++;
        }
      }

      if (kDebugMode) {
        print('Left Count: $leftCount');
      }
      if (kDebugMode) {
        print('Done Count: $doneCount');
      }

      taskCategory.left = leftCount;
      taskCategory.done = doneCount;
    }
    return taskCategories;
  }

  @override
  Future<List<TaskData>> fetchTasksForToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot query = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('tasks')
        .where('dueDateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dueDateTime', isLessThanOrEqualTo: endOfDay)
        .orderBy('dueDateTime')
        .get();

    return query.docs.map((doc) => TaskData.fromFirestore(doc)).toList();
  }
}
