import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'Nav/main_scaffold.dart';

class CritiqueAiApp extends StatelessWidget {
  const CritiqueAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Critique AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MainScaffold(),
    );
  }
}
