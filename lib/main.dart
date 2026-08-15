import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_navigation_screen.dart';

void main() {
  runApp(const KabazaApp());
}

class KabazaApp extends StatelessWidget {
  const KabazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kabaza - Safe Travel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}
