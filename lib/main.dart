import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/medical_info_screen.dart';
import 'screens/claims_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/submit_claim_screen.dart';

void main() {
  runApp(const SmartHealthApp());
}

class SmartHealthApp extends StatefulWidget {
  const SmartHealthApp({super.key});

  @override
  State<SmartHealthApp> createState() => _SmartHealthAppState();
}

class _SmartHealthAppState extends State<SmartHealthApp> {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartHealth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(appState: appState),
        '/dashboard': (context) => DashboardScreen(appState: appState),
        '/medical': (context) => MedicalInfoScreen(appState: appState),
        '/claims': (context) => ClaimsScreen(appState: appState),
        '/submit': (context) => SubmitClaimScreen(appState: appState),
        '/notifications': (context) => NotificationsScreen(appState: appState),
      },
    );
  }
}
