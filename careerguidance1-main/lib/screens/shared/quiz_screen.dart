import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  final questions = const [
    "Do you enjoy solving math problems?",
    "Are you interested in how machines work?",
    "Do you like helping people?",
    "Would you enjoy designing buildings?",
    "Do you like managing or leading teams?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Interest Quiz")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(questions[index]),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_up_alt_outlined, color: Colors.green),
                  SizedBox(width: 10),
                  Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}
