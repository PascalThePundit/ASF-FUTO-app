import 'package:flutter/material.dart';

class VerifyUserScreen extends StatelessWidget {
  final String uid;
  const VerifyUserScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: const Text('Verify User', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Verify User — Coming Soon',
            style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16)),
      ),
    );
  }
}