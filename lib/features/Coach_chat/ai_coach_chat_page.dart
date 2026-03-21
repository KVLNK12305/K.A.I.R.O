import 'package:flutter/material.dart';
import '../../core/models/chat_message.dart';

class AiCoachChatPage extends StatefulWidget {
  const AiCoachChatPage({super.key});

  @override
  State<AiCoachChatPage> createState() => _AiCoachChatPageState();
}

class _AiCoachChatPageState extends State<AiCoachChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage("Welcome back. I've analyzed your weekly data. Your social consistency is dropping.", false),
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text;
    _controller.clear();

    setState(() => _messages.add(ChatMessage(text, true)));

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _messages.add(ChatMessage("Let's focus on '$text' today. Keep pushing.", false)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("CRITIQUE COACH", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (_, i) {
              final msg = _messages[i];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: msg.isUser ? Colors.white : Colors.white.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg.text, style: TextStyle(color: msg.isUser ? Colors.black : Colors.white)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0A0A0A),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ask your coach...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _sendMessage),
          ]),
        ),
      ]),
    );
  }
}
