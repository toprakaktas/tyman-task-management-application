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
  String? get _uid => auth.currentUser?.uid;

  @override
  Future<bool> addTask(TaskData taskData) async {
    try {
      var uuid = const Uuid().v4();
      taskData.id = uuid;
      final uid = _uid;
      if (uid == null) {
        if (kDebugMode) {
          print('No authenticated user.');
        }
        return false;
      }
      await firestore
          .collection('users')
          .doc(uid)
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
      final uid = _uid;
      if (uid == null) {
        if (kDebugMode) {
          print('No authenticated user.');
        }
        return;
      }
      await firestore
          .collection('users')
          .doc(uid)
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
      final uid = _uid;
      if (uid == null) {
        if (kDebugMode) {
          print('No authenticated user.');
        }
        return;
      }
      await firestore
          .collection('users')
          .doc(uid)
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
  Future<List<TaskData>> fetchTasksFuture(
      String category, DateTime date) async {
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      final uid = _uid;
      if (uid == null) {
        if (kDebugMode) {
          print('No authenticated user.');
        }
        return <TaskData>[];
      }
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
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
  Stream<List<TaskData>> fetchTasksStream(String category, DateTime date) {
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final uid = _uid;
    if (uid == null) {
      return Stream<List<TaskData>>.value(<TaskData>[]);
    }

    final stream = firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where('category', isEqualTo: category)
        .where('dueDateTime', isGreaterThanOrEqualTo: start)
        .where('dueDateTime', isLessThanOrEqualTo: end)
        .orderBy('dueDateTime')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskData.fromFirestore(doc)).toList());
    return stream;
  }

  @override
  Future<List<TaskModel>> fetchTaskCounts() async {
    DateTime date = DateTime.now();
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    List<TaskModel> taskCategories = [
      TaskModel.personal(),
      TaskModel.work(),
      TaskModel.health(),
      TaskModel.other()
    ];

    final uid = _uid;
    if (uid == null) {
      if (kDebugMode) {
        print('No authenticated user.');
      }
      return <TaskModel>[];
    }

    for (var taskCategory in taskCategories) {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .where('category', isEqualTo: taskCategory.title)
          .where('dueDateTime', isGreaterThanOrEqualTo: start)
          .where('dueDateTime', isLessThanOrEqualTo: end)
          .get();

      int leftCount = 0;
      int doneCount = 0;

      for (var doc in snapshot.docs) {
        bool completed =
            (doc.data() as Map<String, dynamic>)['completed'] ?? false;
        if (completed == false) {
          leftCount++;
        } else if (completed == true) {
          doneCount++;
        }
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

    final uid = _uid;
    if (uid == null) {
      if (kDebugMode) {
        print('No authenticated user.');
      }
      return <TaskData>[];
    }

    QuerySnapshot query = await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where('dueDateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dueDateTime', isLessThanOrEqualTo: endOfDay)
        .orderBy('dueDateTime')
        .get();

    return query.docs.map((doc) => TaskData.fromFirestore(doc)).toList();
  }
}
