import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation.dart';
import 'admin/admin_dashboard_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SafeAlertApp());
}

class SafeAlertApp extends StatelessWidget {
  const SafeAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Alert',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in -> show login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // Logged in -> check role, then route accordingly
        return FutureBuilder<Map<String, dynamic>?>(
          future: AuthService().getCurrentUserData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final userData = userSnapshot.data;
            final role = userData?["role"] ?? "user";

            if (role == "admin") {
              return const AdminDashboardScreen();
            } else {
              return const MainNavigation();
            }
          },
        );
      },
    );
  }
}