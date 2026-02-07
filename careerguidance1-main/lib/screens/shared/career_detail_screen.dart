import 'package:flutter/material.dart';

class CareerDetailScreen extends StatelessWidget {
  final String field;
  final String category; // "internships" or "certifications"
  final List<String> items;

  const CareerDetailScreen({
    super.key,
    required this.field,
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isInternship = category == "internships";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$field - ${isInternship ? "Internships" : "Certifications"}",
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              isInternship ? Icons.work_outline : Icons.school_outlined,
            ),
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}
