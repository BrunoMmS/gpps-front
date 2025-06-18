import 'package:flutter/material.dart';
import 'package:gpps_front/models/activity.dart';
import 'package:gpps_front/models/task.dart';

import '../../handlers/task_handler.dart';
import '../../models/user_session.dart';
import 'add_task_dialog.dart';

class TaskPanel extends StatefulWidget {
  final Activity activity;
  final Function(Task) onTaskAdded;
  final int idUserCreator;

  const TaskPanel({
    super.key,
    required this.activity,
    required this.onTaskAdded,
    required this.idUserCreator,
  });

  @override
  State<TaskPanel> createState() => _TaskPanelState();
}

class _TaskPanelState extends State<TaskPanel> {
  final TaskHandler taskHandler = TaskHandler();
  late Activity _currentActivity; // Use a mutable variable for activity

  @override
  void initState() {
    super.initState();
    _currentActivity = widget.activity;
  }

  // --- ADD THIS NEW LIFECYCLE METHOD ---
  @override
  void didUpdateWidget(covariant TaskPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activity.id != oldWidget.activity.id) {
      setState(() {
        _currentActivity = widget.activity;
      });
    }
  }
  // ------------------------------------

  void _handleAddTask(BuildContext context) async {
    final newTask = await showDialog<TaskCreate>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (newTask != null) {
      try {
        final createdTask = await taskHandler.createTask(
          _currentActivity.id,
          newTask.description,
          done: newTask.done,
        );
        setState(() {
          _currentActivity.tasks.add(createdTask);
        });
        widget.onTaskAdded(createdTask);
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
            if (widget.idUserCreator == UserSession().user!.id)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _handleAddTask(context),
              ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _currentActivity.tasks.length,
            itemBuilder: (context, index) {
              final task = _currentActivity.tasks[index];
              return ListTile(
                leading: Icon(
                  task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.done ? Colors.greenAccent : Colors.white54,
                ),
                title: Text(
                  task.description,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: !task.done
                    ? IconButton(
                        icon: const Icon(Icons.check, color: Colors.white),
                        tooltip: 'Marcar como hecha',
                        onPressed: () async {
                          try {
                            await taskHandler.setDoneTask(
                              task.id,
                            );
                            setState(() {
                              // Find the task and update its 'done' status
                              final taskIndex = _currentActivity.tasks
                                  .indexWhere((t) => t.id == task.id);
                              if (taskIndex != -1) {
                                _currentActivity.tasks[taskIndex] = Task(
                                  id: task.id,
                                  description: task.description,
                                  done: true, // Mark as done
                                );
                              }
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error al marcar tarea como hecha: $e')),
                            );
                          }
                        },
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}