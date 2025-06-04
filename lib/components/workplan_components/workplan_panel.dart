import 'package:flutter/material.dart';
import 'package:gpps_front/models/activity.dart';
import 'package:gpps_front/models/workplan.dart';

import '../activity_components/activity_card.dart';
import '../activity_components/add_activity_dialog.dart';
import '../task_components/task_panel.dart';

import '../../handlers/activity_handler.dart';

class WorkplanPanel extends StatefulWidget {
  final Workplan workplan;

  const WorkplanPanel({super.key, required this.workplan});

  @override
  State<WorkplanPanel> createState() => _WorkplanPanelState();
}

class _WorkplanPanelState extends State<WorkplanPanel> {
  Activity? selectedActivity;
  final ActivityHandler activityHandler = ActivityHandler(
    baseUrl: "http://127.0.0.1:8000",
  );

  void _addActivity(ActivityCreate activity) async {
    try {
      final createdActivity = await activityHandler.createActivity(
        widget.workplan.id,
        activity,
      );
      setState(() {
        widget.workplan.activities.add(createdActivity);
        selectedActivity = createdActivity;
      });
    } catch (e) {
      // Maneja error (ejemplo: snackbar)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear actividad: $e')));
    }
  }

  void _selectActivity(Activity activity) {
    setState(() {
      selectedActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Actividades",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      final newActivity = await showDialog<ActivityCreate>(
                        context: context,
                        builder: (_) => const AddActivityDialog(),
                      );
                      if (newActivity != null) _addActivity(newActivity);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.workplan.activities.length,
                  itemBuilder: (context, index) {
                    final activity = widget.workplan.activities[index];
                    return ActivityCard(
                      activity: activity,
                      onViewTasks: () => _selectActivity(activity),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(color: Colors.white24),
        Expanded(
          flex: 3,
          child:
              selectedActivity != null
                  ? TaskPanel(
                    activity: selectedActivity!,
                    onTaskAdded: (task) {
                      setState(() {
                        selectedActivity!.tasks.add(task);
                      });
                    },
                  )
                  : const Center(
                    child: Text(
                      "Selecciona una actividad para ver las tareas",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
        ),
      ],
    );
  }
}
