import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'add_edit_task_screen.dart';
import '../services/all_tasks_view.dart';
import '../services/tasks_by_date_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  

  bool _showAllTasks = false;


  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        title: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _authService.logout();
  }


  void _openAddTask() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final userId = user?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MY TASK MANAGER", 
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: Colors.black)
            ),
            Text(
              user?.email ?? "no-email", 
              style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout, size: 18, color: Colors.black),
            onPressed: _confirmLogout,
          )
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                _buildTabButton(false, "DATE TIMELINE"),
                _buildTabButton(true, "ALL TASKS LIST"),
              ],
            ),
          ),
        ),
      ),
  
      body: StreamBuilder(
        stream: _firestoreService.watchUserTasks(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Something went wrong: ${snapshot.error}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }
          final tasks = snapshot.data!;
          if (tasks.isEmpty) {
            return const _EmptyState();
          }
          
          
          return _showAllTasks ? AllTasksView(tasks: tasks) : TasksByDateView(tasks: tasks);
        },
      ),
    
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Widget _buildTabButton(bool targetMode, String title) {
    bool isSel = _showAllTasks == targetMode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showAllTasks = targetMode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSel ? Colors.blue.shade600 : Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isSel ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.black.withOpacity(0.2)),
            const SizedBox(height: 16),
            const Text(
              'NO TASKS YET', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.black)
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first task.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
