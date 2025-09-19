import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';
import 'package:task_manager_firebase_09_09_25/data/models/task_count_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get tasksCollection => _firestore.collection('tasks');

  // Get all tasks
  Stream<QuerySnapshot> getTasksStream() {
    return tasksCollection.orderBy('createdDate', descending: true).snapshots();
  }

  // Get tasks by status
  Stream<QuerySnapshot> getTasksByStatus(String status) {
    return tasksCollection
        .where('status', isEqualTo: status)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  // Add new task
  Future<String> addTask(TaskModel task) async {
    final docRef = await tasksCollection.add(task.toFirestore());
    return docRef.id;
  }

  // Update task
  Future<void> updateTask(String taskId, TaskModel task) async {
    await tasksCollection.doc(taskId).update(task.toFirestore());
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    await tasksCollection.doc(taskId).delete();
  }

  // Get task count by status
  Future<List<TaskCountModel>> getTaskCountByStatus() async {
    final snapshot = await tasksCollection.get();

    // Group by status and count
    final counts = <String, int>{};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'] ?? 'Unknown';
      counts[status] = (counts[status] ?? 0) + 1;
    }

    return counts.entries.map((entry) =>
        TaskCountModel(status: entry.key, count: entry.value)
    ).toList();
  }

  // Get task count by status as stream (real-time updates)
  Stream<List<TaskCountModel>> getTaskCountByStatusStream() {
    return tasksCollection.snapshots().map((snapshot) {
      final counts = <String, int>{};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] ?? 'Unknown';
        counts[status] = (counts[status] ?? 0) + 1;
      }

      return counts.entries.map((entry) =>
          TaskCountModel(status: entry.key, count: entry.value)
      ).toList();
    });
  }
}