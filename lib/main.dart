import 'package:flutter/material.dart';
import 'package:nimo_todo/ui/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NimoTodoApp());
}

class NimoTodoApp extends StatelessWidget {
  const NimoTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nimo Todo Lis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C4DFF)),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
