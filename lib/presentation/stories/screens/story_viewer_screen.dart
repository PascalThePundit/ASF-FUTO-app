import 'package:flutter/material.dart';

class StoryViewerScreen extends StatelessWidget {
  final String storyId;
  const StoryViewerScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: const Text('Story', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Story Viewer — Coming Soon',
            style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16)),
      ),
    );
  }
}