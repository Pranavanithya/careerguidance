import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/video_call_page.dart';

class InteractionScreen extends StatefulWidget {
  final String mentorId;
  final String studentId;

  const InteractionScreen({
    super.key,
    required this.mentorId,
    required this.studentId,
  });

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  Map<String, dynamic>? mentorData;

  @override
  void initState() {
    super.initState();
    fetchMentorDetails();
  }

  Future<void> fetchMentorDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.mentorId)
          .get();
      if (doc.exists) {
        setState(() => mentorData = doc.data());
      } else {
        debugPrint("Mentor not found.");
      }
    } catch (e) {
      debugPrint("Error fetching mentor: $e");
    }
  }

  Future<void> registerInteractionAndStartCall() async {
    await FirebaseFirestore.instance.collection('interactions').add({
      'mentorId': widget.mentorId,
      'studentId': widget.studentId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoCallPage()),
    );
  }
  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch email: $uri");
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch phone: $uri");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (mentorData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String email = mentorData!['email'] ?? 'N/A';
    final String phone = mentorData!['mobile'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🧑‍🏫 ${mentorData!['name'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Expertise: ${mentorData!['expertise'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            const Text("Email:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                if (email != 'N/A') _launchEmail(email);
              },
              child: Text(email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  )),
            ),

            const SizedBox(height: 20),
            const Text("Mobile:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                if (phone != 'N/A') _launchPhone(phone);
              },
              child: Text(phone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  )),
            ),

            const SizedBox(height: 20),
            Text("🎂 Age: ${mentorData!['age'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("👨‍💼 Experience: ${mentorData!['experience'] ?? 'N/A'} years",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("🎓 Preferred Level: ${mentorData!['preferredLevel'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16)),

            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: registerInteractionAndStartCall,
                icon: const Icon(Icons.video_call),
                label: const Text("Start Video Call"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
