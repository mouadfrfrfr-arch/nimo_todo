import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _lock = AppLockController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FutureBuilder<bool>(
          future: _lock.isEnabled(),
          builder: (context, snap) {
            final enabled = snap.data ?? false;
            return SwitchListTile(
              value: enabled,
              title: const Text('App lock'),
              subtitle: const Text('Use device biometric/passcode to open the app.'),
              onChanged: (v) async {
                await _lock.setEnabled(v);
                if (mounted) setState(() {});
              },
              secondary: const Icon(Icons.lock_outline),
            );
          },
        ),
        const ListTile(
          leading: Icon(Icons.verified_user_outlined),
          title: Text('Local encryption'),
          subtitle: Text('Database encrypted on device (SQLCipher).'),
        ),
        const ListTile(
          leading: Icon(Icons.palette_outlined),
          title: Text('Theme'),
          subtitle: Text('Premium themes (Phase 2.1).'),
        ),
        const ListTile(
          leading: Icon(Icons.import_export),
          title: Text('Export / Import'),
          subtitle: Text('Local export (Phase 3).'),
        ),
      ],
    );
  }
}
