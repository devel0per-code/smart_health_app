import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/claim_submission_form.dart';

class SubmitClaimScreen extends StatelessWidget {
  const SubmitClaimScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit a new claim')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ClaimSubmissionForm(
            appState: appState,
            onSubmitted: () => Navigator.pushReplacementNamed(context, '/claims'),
          ),
        ),
      ),
    );
  }
}
