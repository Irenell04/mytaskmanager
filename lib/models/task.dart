import 'package:cloud_firestore/cloud_firestore.dart';


class Task {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date; 
  final DateTime createdAt;
  final bool isDone;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.createdAt,
    this.isDone = false,
  });

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDone: data['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'isDone': isDone,
    };
  }
}
