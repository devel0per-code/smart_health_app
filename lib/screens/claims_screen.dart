import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/claims_list.dart';

class ClaimsScreen extends StatelessWidget {
  const ClaimsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your claims')),
      body: ClaimsList(
        appState: appState,
        onSubmit: () => Navigator.pushNamed(context, '/submit'),
      ),
    );
  }
}
