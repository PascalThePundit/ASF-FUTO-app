import 'package:flutter/material.dart';

class HymnDetailScreen extends StatelessWidget {
  final String hymnId;
  const HymnDetailScreen({super.key, required this.hymnId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: const Text('Hymn', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Hymn Detail — Coming Soon',
            style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16)),
      ),
    );
  }
}