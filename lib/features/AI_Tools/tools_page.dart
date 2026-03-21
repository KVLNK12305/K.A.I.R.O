import 'package:flutter/material.dart';
import 'widgets/tool_card.dart';

class AiToolsPage extends StatelessWidget {
  const AiToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("AI DIAGNOSTICS", style: TextStyle(fontSize: 14, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: const [
          ToolCard(icon: Icons.accessibility_new, title: "Physique Scan", color: Colors.blue),
          ToolCard(icon: Icons.center_focus_strong, title: "Posture Analyzer", color: Colors.green),
          ToolCard(icon: Icons.restaurant, title: "Food Scanner", color: Colors.orange),
          ToolCard(icon: Icons.checkroom, title: "Outfit Rating", color: Colors.purple),
        ],
      ),
    );
  }
}
