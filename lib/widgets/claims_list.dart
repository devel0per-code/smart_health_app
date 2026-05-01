import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';

class ClaimsList extends StatelessWidget {
  const ClaimsList({super.key, required this.appState, required this.onSubmit});

  final AppState appState;
  final VoidCallback onSubmit;

  Color _statusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.approved:
        return Colors.green;
      case ClaimStatus.rejected:
        return Colors.red;
      case ClaimStatus.processing:
      case ClaimStatus.submitted:
        return Colors.orange;
    }
  }

  String _statusLabel(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.rejected:
        return 'Rejected';
      case ClaimStatus.processing:
        return 'Processing';
      case ClaimStatus.submitted:
        return 'Submitted';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total claims', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('${appState.claims.length}', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('Submit new claim'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...appState.claims.map((claim) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(claim.description),
              subtitle: Text('${claim.date} • ${claim.documentName}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${claim.amount.toStringAsFixed(2)} ZAR', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    _statusLabel(claim.status),
                    style: TextStyle(color: _statusColor(claim.status), fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
