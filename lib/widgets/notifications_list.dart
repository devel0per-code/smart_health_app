import 'package:flutter/material.dart';

import '../models.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final note = notifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              note.read ? Icons.notifications_active : Icons.notifications_none,
              color: note.read ? Colors.green : Colors.red,
            ),
            title: Text(note.title),
            subtitle: Text('${note.message}\n${note.date}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
