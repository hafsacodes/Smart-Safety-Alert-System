import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // Ensures Flutter is fully initialized before using Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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
      home: const LoginScreen(),
    );
  }
}