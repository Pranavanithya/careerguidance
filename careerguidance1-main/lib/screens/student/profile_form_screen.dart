import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../shared/ai_suggestion_screen.dart'; // ✅ Make sure this import path is correct

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  final Map<String, List<String>> dropdownOptions = {
    'field': [
      'Engineering', 'Chemistry', 'Physics', 'Law', 'Marketing', 'Medicine',
      'Computer Science', 'Education', 'Business', 'Architecture', 'Music',
      'Biology', 'Finance', 'Psychology', 'Art'
    ],
    'extracurricular_activities': ['Excellent', 'Basic', 'Good', 'None', 'Average', 'Very Good', 'Expert'],
    'internships': ['None', 'Average', 'Basic'],
    'projects': ['Average', 'None', 'Good', 'Very Good', 'Basic'],
    'leadership_positions': ['None', 'Basic'],
    'field_specific_courses': ['Good', 'Expert', 'Excellent', 'Basic', 'None', 'Average', 'Very Good'],
    'research_experience': ['Basic', 'None'],
    'coding_skills': ['Very Good', 'Good', 'Basic', 'None', 'Average'],
    'communication_skills': ['Very Good', 'Basic', 'Average', 'Good', 'None'],
    'problem_solving_skills': ['Average', 'None', 'Basic', 'Good', 'Very Good'],
    'teamwork_skills': ['Average', 'Good', 'Basic', 'Very Good', 'None'],
    'analytical_skills': ['Basic', 'None', 'Average', 'Very Good', 'Good'],
    'presentation_skills': ['None', 'Good', 'Basic', 'Average', 'Very Good'],
    'networking_skills': ['Basic', 'None', 'Very Good', 'Average', 'Good'],
    'industry_certifications': ['Basic', 'None'],
  };

  void _showBottomSheet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.psychology_alt_rounded,
                    size: 48, color: Color(0xFF6A1B9A)),
                const SizedBox(height: 12),
                const Text(
                  "Let our AI analyze your profile and suggest the right career path!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showProfileSummary,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B1FA2), Color(0xFFE040FB)],
                          ),
                        ),
                        child: InkWell(
                          onTap: _goToDashboard,
                          borderRadius: BorderRadius.circular(12),
                          child: const Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _showProfileSummary() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Profile Summary"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _formData.entries
                .map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("${e.key.toUpperCase()}: ${e.value}"),
              ),
            )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _goToDashboard() async {
    Navigator.pop(context);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .set({
          ..._formData,
          'email': user.email ?? '',
          'timestamp': Timestamp.now(),
        });
      } catch (e) {
        debugPrint("🔥 Firestore error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving profile to Firestore")),
        );
        return;
      }
    }

    final url = Uri.parse("https://flask-api-y4tt.onrender.com/predict");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "Field": _formData['field'],
          "GPA": double.tryParse(_formData['gpa']) ?? 0.0,
          "Extracurricular_Activities": _formData['extracurricular_activities'],
          "Internships": _formData['internships'],
          "Projects": _formData['projects'],
          "Leadership_Positions": _formData['leadership_positions'],
          "Field_Specific_Courses": _formData['field_specific_courses'],
          "Research_Experience": _formData['research_experience'],
          "Coding_Skills": _formData['coding_skills'],
          "Communication_Skills": _formData['communication_skills'],
          "Problem_Solving_Skills": _formData['problem_solving_skills'],
          "Teamwork_Skills": _formData['teamwork_skills'],
          "Analytical_Skills": _formData['analytical_skills'],
          "Presentation_Skills": _formData['presentation_skills'],
          "Networking_Skills": _formData['networking_skills'],
          "Industry_Certifications": _formData['industry_certifications'],
        }),
      );

      if (response.statusCode == 200) {
        final prediction = json.decode(response.body)['predicted_career'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AiSuggestionScreen(career: prediction),
          ),
        );
      } else {
        throw Exception("Failed to get prediction: ${response.body}");
      }
    } catch (e) {
      debugPrint("🧨 API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching AI suggestion")),
      );
    }
  }

  Widget _buildTextField(String label, String key,
      {TextInputType keyboardType = TextInputType.text}) {
    if (dropdownOptions.containsKey(key)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: dropdownOptions[key]!
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          validator: (value) => (value == null || value.isEmpty) ? "Select $label" : null,
          onChanged: (value) => _formData[key] = value!,
        ),
      );
    }

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
        validator: (value) {
          if (value == null || value.isEmpty) return "Enter $label";
          if (key == 'phone_number' && value.length < 10) {
            return "Enter a valid phone number";
          }
          return null;
        },
        onSaved: (value) => _formData[key] = value!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Student Profile"),
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
                  color: Colors.deepPurple.withAlpha((0.05 * 255).toInt()),
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
                    "Complete Your Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField("Name", "name"),
                  _buildTextField("Phone Number", "phone_number", keyboardType: TextInputType.phone),
                  _buildTextField("Field", "field"),
                  _buildTextField("GPA", "gpa", keyboardType: TextInputType.number),
                  _buildTextField("Extracurricular Activities", "extracurricular_activities"),
                  _buildTextField("Internships", "internships"),
                  _buildTextField("Projects", "projects"),
                  _buildTextField("Leadership Positions", "leadership_positions"),
                  _buildTextField("Field Specific Courses", "field_specific_courses"),
                  _buildTextField("Research Experience", "research_experience"),
                  _buildTextField("Coding Skills", "coding_skills"),
                  _buildTextField("Communication Skills", "communication_skills"),
                  _buildTextField("Problem Solving Skills", "problem_solving_skills"),
                  _buildTextField("Teamwork Skills", "teamwork_skills"),
                  _buildTextField("Analytical Skills", "analytical_skills"),
                  _buildTextField("Presentation Skills", "presentation_skills"),
                  _buildTextField("Networking Skills", "networking_skills"),
                  _buildTextField("Industry Certifications", "industry_certifications"),
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
                      onTap: _showBottomSheet,
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
