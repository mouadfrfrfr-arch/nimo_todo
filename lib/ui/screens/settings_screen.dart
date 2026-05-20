import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text('App lock'),
          subtitle: Text('Passcode / biometric (Phase 2).'),
        ),
        ListTile(
          leading: Icon(Icons.palette_outlined),
          title: Text('Theme'),
          subtitle: Text('Premium themes (Phase 2).'),
        ),
        ListTile(
          leading: Icon(Icons.import_export),
          title: Text('Export / Import'),
          subtitle: Text('Local export (Phase 3).'),
        ),
      ],
    );
  }
}
