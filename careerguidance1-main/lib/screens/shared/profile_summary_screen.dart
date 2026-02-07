import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/shared/role_selection_screen.dart';

class ProfileSummaryScreen extends StatefulWidget {
  final String role; // "student" or "mentor"
  const ProfileSummaryScreen({super.key, required this.role});

  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  Map<String, dynamic>? _profileData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection(widget.role == "student" ? "students" : "mentors")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        _profileData = doc.data();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  Widget _buildProfileTile(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${key.toUpperCase()}: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Expanded(
            child: Text(value ?? '-', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Summary"),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _profileData == null
          ? const Center(child: Text("No profile found."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _profileData!.entries.map((entry) {
                    if (entry.key == "timestamp") return const SizedBox();
                    return _buildProfileTile(
                      entry.key,
                      entry.value?.toString(),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
