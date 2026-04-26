import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const ProviderScope(child: ElderEaseApp()));
}

class ElderEaseApp extends StatelessWidget {
  const ElderEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElderEase',
      theme: AppTheme.premiumTheme,
      home: const RoleSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
