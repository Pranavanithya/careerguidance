import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class CareerPortalScreen extends StatefulWidget {
  const CareerPortalScreen({super.key});

  @override
  State<CareerPortalScreen> createState() => _CareerPortalScreenState();
}

class _CareerPortalScreenState extends State<CareerPortalScreen> {
  List<dynamic> careerData = [];

  @override
  void initState() {
    super.initState();
    loadCareerData();
  }

  Future<void> loadCareerData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/career_recommendations.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      careerData = jsonMap['career_recommendations'];
    });
  }

  void _navigateToDetail(Map<String, dynamic> career) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareerDetailScreen(career: career),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Recommendations")),
      body: careerData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: careerData.length,
        itemBuilder: (context, index) {
          final career = careerData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              title: Text(
                career['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Certifications: ${career['certifications'].length}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Internships: ${career['internships'].length}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              onTap: () => _navigateToDetail(career),
            ),
          );
        },
      ),
    );
  }
}

class CareerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> career;

  const CareerDetailScreen({super.key, required this.career});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(career['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Certifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...career['certifications'].map<Widget>((cert) => ListTile(
              title: Text(cert['title']),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL(cert['link']),
            )),
            const SizedBox(height: 16),
            const Text(
              'Internships',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...career['internships'].map<Widget>((intern) => ListTile(
              title: Text(intern['title']),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL(intern['link']),
            )),
          ],
        ),
      ),
    );
  }
}