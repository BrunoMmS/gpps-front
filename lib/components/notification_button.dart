import 'package:flutter/material.dart';
import 'package:gpps_front/handlers/notification_handler.dart';
import 'package:gpps_front/models/notification.dart' as model;
import '../models/user_session.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  List<model.Notification> notifications = [];
  bool hasUnread = false;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final user = UserSession().user;
      if (user == null) return;

      final fetched = await NotificationHandler.fetchNotifications(user.id);
      if (!mounted) return;
      setState(() {
        notifications = fetched;
        hasUnread = fetched.any((n) => !n.read);
      });
    } catch (e) {}
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Notificaciones"),
            content: SizedBox(
              width: 300,
              height: 300,
              child:
                  notifications.isEmpty
                      ? const Center(child: Text("No hay notificaciones."))
                      : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          return ListTile(
                            leading: Icon(
                              notif.read
                                  ? Icons.mark_email_read
                                  : Icons.mark_email_unread,
                              color: notif.read ? Colors.grey : Colors.red,
                            ),
                            title: Text(notif.message),
                            onTap: () async {
                              if (!notif.read) {
                                await NotificationHandler.markAsRead(notif.id);
                                _fetchNotifications(); // Refresh
                              }
                            },
                          );
                        },
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: Colors.white,
          onPressed: _showNotificationDialog,
        ),
        if (hasUnread)
          const Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
          ),
      ],
    );
  }
}
