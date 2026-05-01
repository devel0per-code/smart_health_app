import 'package:flutter/material.dart';

import '../app_state.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.appState, required this.onAuthenticated});

  final AppState appState;
  final VoidCallback onAuthenticated;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _registerMode = false;

  void _showMessage(String message, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_registerMode) {
      final name = _nameController.text.trim();
      final confirmed = widget.appState.register(name: name, email: email, password: password);
      if (!confirmed) {
        _showMessage('Email already registered. Please log in.', Colors.red);
        return;
      }
      _showMessage('Registration successful. Welcome, $name!', Colors.green);
    } else {
      final success = widget.appState.login(email: email, password: password);
      if (!success) {
        _showMessage('Login failed. Check your email and password.', Colors.red);
        return;
      }
      _showMessage('Login successful. Welcome back!', Colors.green);
    }

    widget.onAuthenticated();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _registerMode ? 'Create an account' : 'Login to SmartHealth',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (_registerMode)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
                ),
              if (_registerMode) const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              if (_registerMode) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm password'),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_registerMode ? 'Register' : 'Login'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _registerMode = !_registerMode);
                },
                child: Text(_registerMode ? 'Already have an account? Login' : 'Create a new account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
