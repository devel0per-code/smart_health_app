import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/notifications_list.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    widget.appState.markAllNotificationsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: NotificationsList(notifications: widget.appState.notifications),
    );
  }
}
