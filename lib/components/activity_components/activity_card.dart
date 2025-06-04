import 'package:flutter/material.dart';
import 'package:gpps_front/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onViewTasks;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onViewTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[700],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(activity.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          "Duración: ${activity.duration} hs",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility, color: Colors.tealAccent),
          onPressed: onViewTasks,
        ),
      ),
    );
  }
}
