import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectRow extends StatelessWidget {
  final Project project;

  const ProjectRow({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          project.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          project.active ? "Confirmado" : "No Confirmado",
          style: TextStyle(
            color: project.active ? Colors.greenAccent : Colors.redAccent,
            fontSize: 14,
          ),
        ),
        trailing: TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/projectDetails', arguments: project);
          },
          icon: const Icon(Icons.visibility, size: 18),
          label: const Text("Ver"),
          style: TextButton.styleFrom(foregroundColor: Colors.lightBlueAccent),
        ),
      ),
    );
  }
}
