import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/video_call_page.dart';

class MentorInteractionScreen extends StatelessWidget {
  const MentorInteractionScreen({super.key});

  Future<Map<String, dynamic>> getStudentData(String studentId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (doc.exists) {
        return doc.data()!;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMentorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Connected Students")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('interactions')
            .where('mentorId', isEqualTo: currentMentorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final studentId = docs[index]['studentId'];

              return FutureBuilder<Map<String, dynamic>>(
                future: getStudentData(studentId),
                builder: (context, snapshot) {
                  final studentData = snapshot.data ?? {};

                  final studentName = studentData['name'] ?? 'Unknown';
                  final email = studentData['email'] ?? '';
                  final phone = studentData['phone_number'] ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Student: $studentName",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("Email: ",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse('mailto:$email')),
                            child: Text(email, style: const TextStyle(color: Colors.blue)),
                          ),
                          const SizedBox(height: 6),
                          Text("Mobile: ",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse('tel:$phone')),
                            child: Text(phone, style: const TextStyle(color: Colors.blue)),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            children: [
                              for (var key in [
                                'age', 'experience', 'preferred_level', 'analytical_skills',
                                'coding_skills', 'communication_skills',
                                'extracurricular_activities', 'field', 'field_specific_courses',
                                'gpa', 'industry_certifications', 'internships',
                                'leadership_positions', 'networking_skills',
                                'presentation_skills', 'problem_solving_skills',
                                'projects', 'research_experience', 'teamwork_skills'
                              ])
                                if (studentData.containsKey(key))
                                  Text("${key.replaceAll('_', ' ').toUpperCase()}: ${studentData[key]}",
                                      style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chat),
                                onPressed: () {
                                  // TODO: implement chat
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.video_call),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const VideoCallPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
