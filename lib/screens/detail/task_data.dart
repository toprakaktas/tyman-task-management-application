import 'package:cloud_firestore/cloud_firestore.dart';

class TaskData {
  String id;
  String category;
  String description;
  DateTime dueDateTime;
  bool completed;

  TaskData(
      {this.id = '',
      required this.category,
      required this.description,
      required this.dueDateTime,
      this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'dueDateTime': dueDateTime,
      'completed': completed
    };
  }

  factory TaskData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskData(
        id: doc.id,
        category: data['category'] as String,
        description: data['description'] as String,
        dueDateTime: (data['dueDateTime'] as Timestamp).toDate(),
        completed: data['completed'] ?? false);
  }
}
