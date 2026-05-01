import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartHealth login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AuthForm(
            appState: appState,
            onAuthenticated: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
        ),
      ),
    );
  }
}
