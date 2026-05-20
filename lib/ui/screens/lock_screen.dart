import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _lock = AppLockController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final ok = await _lock.authenticate();
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context, true);
      } else {
        setState(() => _error = 'Authentication failed.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 56, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text('Locked', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('Authenticate to continue.'),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _busy ? null : _unlock,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(_busy ? 'Checking…' : 'Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
