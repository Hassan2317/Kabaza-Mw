import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'auth/role_selection_screen.dart';

void main() {
  runApp(const ProviderScope(child: KabazaApp()));
}

class KabazaApp extends StatelessWidget {
  const KabazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kabaza - Safe Travel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
