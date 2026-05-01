import 'package:flutter/material.dart';

import '../models.dart';

class MedicalInfoCard extends StatelessWidget {
  const MedicalInfoCard({super.key, required this.info, required this.userName});

  final MedicalInfo info;
  final String userName;

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Hello, $userName', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Membership details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                _buildRow('Member ID', info.memberId),
                _buildRow('Plan', info.planName),
                _buildRow('DOB', info.dateOfBirth),
                _buildRow('Blood type', info.bloodType),
                _buildRow('Allergies', info.allergies),
                _buildRow('Conditions', info.conditions),
                _buildRow('Phone', info.phone),
                _buildRow('Email', info.email),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
