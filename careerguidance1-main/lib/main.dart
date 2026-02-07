import 'package:career_guidance/screens/mentor/dashboard_screen.dart';
import 'package:career_guidance/screens/shared/ai_suggestion_screen.dart';
import 'package:career_guidance/screens/student/dashboard_screen.dart';
import 'package:career_guidance/screens/shared/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Decide which screen to show on launch
  Future<Widget> _determineStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final role = await FirestoreService().getUserRole();
      if (role == 'student') {
        return const StudentDashboardScreen();
      } else if (role == 'mentor') {
        return const MentorDashboardScreen();
      }
    }

    return const RoleSelectionScreen(); // Default if not logged in or role not found
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Guidance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A), // Deep Purple
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black87,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),

      // ✅ Route setup
      onGenerateRoute: (settings) {
        if (settings.name == '/ai') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => AiSuggestionScreen(career: args), // FIXED ✅
          );
        }
        return null; // fallback
      },

      // ✅ Start screen decided by Firebase login + role
      home: FutureBuilder<Widget>(
        future: _determineStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}