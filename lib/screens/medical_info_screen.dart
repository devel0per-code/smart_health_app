import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/medical_info_card.dart';

class MedicalInfoScreen extends StatelessWidget {
  const MedicalInfoScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final info = appState.medicalInfo;
    final userName = appState.currentUser?.name ?? 'Member';

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MedicalInfoCard(info: info, userName: userName),
      ),
    );
  }
}
