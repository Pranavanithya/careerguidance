import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'interaction_screen.dart';

class MentorListScreen extends StatelessWidget {
  const MentorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Available Mentors"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'mentor')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mentors = snapshot.data!.docs;

          if (mentors.isEmpty) {
            return const Center(child: Text("No mentors available."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: mentors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = mentors[index].data() as Map<String, dynamic>;
              final mentorId = mentors[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  leading: const CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person, size: 26),
                  ),
                  title: Text(
                    data['name'] ?? 'Unnamed Mentor',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(data['expertise'] ?? 'No expertise'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InteractionScreen(
                          mentorId: mentorId,
                          studentId: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
