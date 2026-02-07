import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  // 🧪 Mock student data (replace later with API)
  final List<Map<String, String>> _students = const [
    {
      "name": "Ajai Kumar",
      "age": "17",
      "type": "School",
      "domain": "AI & Robotics",
    },
    {
      "name": "Meena Sharma",
      "age": "20",
      "type": "College",
      "domain": "Data Science",
    },
    {
      "name": "Rahul Das",
      "age": "18",
      "type": "School",
      "domain": "Game Development",
    },
    {
      "name": "Priya Iyer",
      "age": "22",
      "type": "College",
      "domain": "Web Development",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return _studentCard(student);
        },
      ),
    );
  }

  Widget _studentCard(Map<String, String> student) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student['name'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.cake_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Age: ${student['age']}"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.school, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Type: ${student['type']}"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Interested in: ${student['domain']}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
