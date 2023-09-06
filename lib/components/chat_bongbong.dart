import 'package:flutter/material.dart';

class ChatBongBong extends StatelessWidget {
  final String message;
  const ChatBongBong({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.blue,
      ),
      child: Text(message, style: TextStyle(fontSize: 18, color: Colors.white),),
    );
  }
}
