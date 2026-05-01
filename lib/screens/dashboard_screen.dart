import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final userName = appState.currentUser?.name ?? 'Member';
    final pendingClaims = appState.claims.where((claim) => claim.status != ClaimStatus.approved).length;
    final unreadNotifications = appState.notifications.where((note) => !note.read).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartHealth Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              appState.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Welcome back, $userName!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety, color: Colors.blue),
                title: const Text('Personal medical information'),
                subtitle: const Text('View your plan details, allergies and conditions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/medical'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.green),
                title: const Text('Monthly claims'),
                subtitle: Text('$pendingClaims claims pending or processing'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/claims'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.orange),
                title: const Text('Submit a new claim'),
                subtitle: const Text('Upload documents and send a claim request'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/submit'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.red),
                title: const Text('Claim notifications'),
                subtitle: Text('$unreadNotifications unread updates'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Latest claim activity', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...appState.claims.take(3).map((claim) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(claim.description),
                  subtitle: Text('${claim.date} • ${claim.amount.toStringAsFixed(2)} ZAR'),
                  trailing: Text(
                    claim.status.name.toUpperCase(),
                    style: TextStyle(
                      color: claim.status == ClaimStatus.approved
                          ? Colors.green
                          : claim.status == ClaimStatus.rejected
                              ? Colors.red
                              : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...appState.notifications.take(2).map((note) {
              return ListTile(
                leading: Icon(
                  note.read ? Icons.mark_email_read : Icons.mark_email_unread,
                  color: note.read ? Colors.grey : Colors.red,
                ),
                title: Text(note.title),
                subtitle: Text(note.message),
              );
            }),
            if (appState.notifications.length > 2)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  child: const Text('View all notifications'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
