import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';
import 'package:nimo_todo/ui/screens/passcode_setup_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _lock = AppLockController();

  static const _delayOptions = <int, String>{
    0: 'Immediately',
    30: 'After 30 seconds',
    60: 'After 1 minute',
    300: 'After 5 minutes',
  };

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
              subtitle: const Text('Use biometric or passcode to open the app.'),
              onChanged: (v) async {
                await _lock.setEnabled(v);
                if (mounted) setState(() {});
              },
              secondary: const Icon(Icons.lock_outline),
            );
          },
        ),
        FutureBuilder<bool>(
          future: _lock.isEnabled(),
          builder: (context, snap) {
            final enabled = snap.data ?? false;
            return FutureBuilder<String?>(
              future: _lock.passcode(),
              builder: (context, pSnap) {
                final hasPasscode = (pSnap.data ?? '').isNotEmpty;
                return ListTile(
                  enabled: enabled,
                  leading: const Icon(Icons.password_outlined),
                  title: const Text('Passcode'),
                  subtitle: Text(hasPasscode ? 'Passcode set' : 'Not set'),
                  trailing: hasPasscode
                      ? TextButton(
                          onPressed: !enabled
                              ? null
                              : () async {
                                  await _lock.setPasscode(null);
                                  if (mounted) setState(() {});
                                },
                          child: const Text('Remove'),
                        )
                      : null,
                  onTap: !enabled
                      ? null
                      : () async {
                          final ok = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(builder: (_) => const PasscodeSetupScreen()),
                          );
                          if (ok == true && mounted) setState(() {});
                        },
                );
              },
            );
          },
        ),
        FutureBuilder<bool>(
          future: _lock.isEnabled(),
          builder: (context, snap) {
            final enabled = snap.data ?? false;
            return FutureBuilder<int>(
              future: _lock.lockDelaySeconds(),
              builder: (context, dSnap) {
                final delay = dSnap.data ?? 0;
                return ListTile(
                  enabled: enabled,
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Lock delay'),
                  subtitle: Text(_delayOptions[delay] ?? '${delay}s'),
                  onTap: !enabled
                      ? null
                      : () async {
                          final picked = await showModalBottomSheet<int>(
                            context: context,
                            showDragHandle: true,
                            builder: (_) => SafeArea(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  for (final e in _delayOptions.entries)
                                    ListTile(
                                      title: Text(e.value),
                                      trailing: (delay == e.key) ? const Icon(Icons.check) : null,
                                      onTap: () => Navigator.pop(context, e.key),
                                    )
                                ],
                              ),
                            ),
                          );

                          if (picked == null) return;
                          await _lock.setLockDelaySeconds(picked);
                          if (mounted) setState(() {});
                        },
                );
              },
            );
          },
        ),
        FutureBuilder<bool>(
          future: _lock.isEnabled(),
          builder: (context, snap) {
            final enabled = snap.data ?? false;
            return FutureBuilder<bool>(
              future: _lock.lockOnBackground(),
              builder: (context, bSnap) {
                final v = bSnap.data ?? true;
                return SwitchListTile(
                  enabled: enabled,
                  value: v,
                  secondary: const Icon(Icons.visibility_off_outlined),
                  title: const Text('Lock when backgrounded'),
                  subtitle: const Text('Require unlock after leaving the app.'),
                  onChanged: !enabled
                      ? null
                      : (nv) async {
                          await _lock.setLockOnBackground(nv);
                          if (mounted) setState(() {});
                        },
                );
              },
            );
          },
        ),
        const Divider(height: 28),
        const ListTile(
          leading: Icon(Icons.verified_user_outlined),
          title: Text('Local encryption'),
          subtitle: Text('Database encrypted on device (SQLCipher).'),
        ),
        const ListTile(
          leading: Icon(Icons.palette_outlined),
          title: Text('Theme'),
          subtitle: Text('Premium themes (later).'),
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
