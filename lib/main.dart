import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nimo_todo/ui/screens/start_screen.dart';
import 'package:nimo_todo/ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NimoTodoApp());
}

class NimoTodoApp extends StatefulWidget {
  const NimoTodoApp({super.key});

  @override
  State<NimoTodoApp> createState() => _NimoTodoAppState();
}

class _NimoTodoAppState extends State<NimoTodoApp> with WidgetsBindingObserver {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _obscure = state != AppLifecycleState.resumed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Nimo Todo Lis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const StartScreen(),
    );

    if (!_obscure) return app;

    return Stack(
      children: [
        app,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withOpacity(0.10)),
          ),
        ),
      ],
    );
  }
}
