import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../widgets/task_tile.dart';
import '../screens/add_edit_task_screen.dart';

class TasksByDateView extends StatelessWidget {
  final List<Task> tasks;

  const TasksByDateView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final Map<String, List<Task>> grouped = {};

    for (final task in tasks) {
      final key = dateFormat.format(task.date);
      grouped.putIfAbsent(key, () => []).add(task);
    }

    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final dayTasks = grouped[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                dateKey,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.indigo.shade700,
                ),
              ),
            ),
            ...dayTasks.map(
              (task) => TaskTile(
                task: task,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
