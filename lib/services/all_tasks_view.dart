import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../widgets/task_tile.dart';
import '../screens/add_edit_task_screen.dart';

class AllTasksView extends StatelessWidget {
  final List<Task> tasks;

  const AllTasksView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          showDate: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
          ),
        );
      },
    );
  }
}
