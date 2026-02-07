import 'package:career_guidance/screens/mentor/profile_form_screen.dart';
import 'package:career_guidance/screens/mentor/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:career_guidance/services/firestore_service.dart';

class MentorLoginScreen extends StatefulWidget {
  const MentorLoginScreen({super.key});

  @override
  State<MentorLoginScreen> createState() => _MentorLoginScreenState();
}

class _MentorLoginScreenState extends State<MentorLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _loginMentor() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ✅ Fetch role from Firestore
      final role = await _firestore.getUserRole();

      if (role != 'mentor') {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'wrong-role',
          message: 'This email is not registered as a mentor.',
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MentorProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF6A1B9A)),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Mentor Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Welcome back, Mentor!"),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                    validator: (val) => val!.isEmpty ? "Enter email" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Password", Icons.lock),
                    validator: (val) => val!.isEmpty ? "Enter password" : null,
                  ),
                  const SizedBox(height: 32),
                  _loading
                      ? const CircularProgressIndicator()
                      : Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B1FA2), Color(0xFFE040FB)],
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _loginMentor,
                      child: const Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MentorSignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color(0xFF6A1B9A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}