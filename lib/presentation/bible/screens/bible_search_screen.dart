import 'package:flutter/material.dart';

class BibleSearchScreen extends StatelessWidget {
  const BibleSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: const Text('Search Bible', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Bible Search — Coming Soon',
            style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16)),
      ),
    );
  }
}