import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({super.key});

  static const String meetUrl = 'https://meet.google.com/ssr-brag-hym';

  Future<void> _joinGoogleMeet() async {
    final Uri uri = Uri.parse(meetUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Google Meet URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Google Meet'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _joinGoogleMeet,
          icon: const Icon(Icons.video_call),
          label: const Text("Join Meeting"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
