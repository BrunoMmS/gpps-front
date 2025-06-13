import 'package:flutter/material.dart';
import 'package:gpps_front/models/activity.dart';
import 'package:gpps_front/models/task.dart';

import '../../handlers/task_handler.dart';
import '../../models/user_session.dart';
import 'add_task_dialog.dart';

class TaskPanel extends StatelessWidget {
  final Activity activity;
  final Function(Task) onTaskAdded;
  final int idUserCreator;
  final TaskHandler taskHandler = TaskHandler();

  TaskPanel({
    super.key,
    required this.activity,
    required this.onTaskAdded,
    required this.idUserCreator,
  });

  void _handleAddTask(BuildContext context) async {
    final newTask = await showDialog<TaskCreate>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (newTask != null) {
      try {
        final createdTask = await taskHandler.createTask(
          activity.id,
          newTask.description,
          done: newTask.done,
        );
        onTaskAdded(createdTask);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear tarea: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Tareas",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const Spacer(),
            if (idUserCreator == UserSession().user!.id)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _handleAddTask(context),
              ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: activity.tasks.length,
            itemBuilder: (context, index) {
              final task = activity.tasks[index];
              return ListTile(
                leading: Icon(
                  task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.done ? Colors.greenAccent : Colors.white54,
                ),
                title: Text(
                  task.description,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
