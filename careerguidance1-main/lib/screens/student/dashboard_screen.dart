import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/career_portal_screen.dart';
import '../shared/quiz_screen.dart';
import '../shared/profile_summary_screen.dart';
import 'mentor_list_screen.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  void _showLogoutMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 10, 100),
      items: [
        PopupMenuItem(
          child: const Text('View Profile'),
          onTap: () {
            Future.delayed(
              Duration.zero,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileSummaryScreen(role: "student"),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.white30,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showLogoutMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _dashboardCard(
              context,
              icon: Icons.group,
              title: "Mentor Interaction",
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MentorListScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _dashboardCard(
              context,
              icon: Icons.work_outline,
              title: "Career Portal",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CareerPortalScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 30,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
