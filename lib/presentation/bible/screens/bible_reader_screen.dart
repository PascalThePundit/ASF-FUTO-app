import 'package:flutter/material.dart';

class BibleReaderScreen extends StatelessWidget {
  final String book;
  final int chapter;
  final String version;
  const BibleReaderScreen({
    super.key,
    required this.book,
    required this.chapter,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: Text('$book $chapter', style: const TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Bible Reader — Coming Soon',
            style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16)),
      ),
    );
  }
}