import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _tasksRef =
      FirebaseFirestore.instance.collection('tasks');


  Stream<List<Task>> watchUserTasks(String userId) {
    return _tasksRef
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addTask({
    required String userId,
    required String title,
    required String description,
    required DateTime date,
  }) {
    return _tasksRef.add({
      'userId': userId,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
  }) {
    return _tasksRef.doc(taskId).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> deleteTask(String taskId) {
    return _tasksRef.doc(taskId).delete();
  }

  /// Flips a task's completed state.
  Future<void> setTaskDone(String taskId, bool isDone) {
    return _tasksRef.doc(taskId).update({'isDone': isDone});
  }
}
