import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';

class MentorProfileScreen extends StatefulWidget {
  const MentorProfileScreen({super.key});

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  Future<void> _saveProfileAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users') // 🔄 Changed from 'mentors' to 'users'
              .doc(user.uid)
              .set({
                ..._formData,
                'email': user.email ?? '',
                'role': 'mentor', // ✅ This makes sure mentors are listed
                'timestamp': Timestamp.now(),
              });
        } catch (e) {
          debugPrint('❌ Firestore Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to save mentor profile."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MentorDashboardScreen()),
      );
    }
  }

  Widget _buildTextField(
    String label,
    String key, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Enter $label" : null,
        onSaved: (value) => _formData[key] = value!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Mentor Profile"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Complete Your Mentor Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField("Full Name", "name"),
                  _buildTextField(
                    "Age",
                    "age",
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField("Area of Expertise", "expertise"),
                  _buildTextField(
                    "Years of Experience",
                    "experience",
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField("Languages Known", "languages"),
                  _buildTextField(
                    "Preferred Student Level (School/College)",
                    "preferred_level",
                  ),
                  _buildTextField(
                    "Contact Number",
                    "mobile",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  Container(
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
                      onTap: _saveProfileAndNavigate,
                      child: const Center(
                        child: Text(
                          "Proceed",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
