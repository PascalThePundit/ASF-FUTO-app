import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  final String roomId;
  final String roomName;
  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5276),
        title: Text(
          roomName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Chat Room — Coming Soon',
          style: TextStyle(color: Color(0xFF0D2B3E), fontSize: 16),
        ),
      ),
    );
  }
}