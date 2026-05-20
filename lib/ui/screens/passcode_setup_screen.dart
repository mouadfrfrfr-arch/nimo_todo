import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';

class PasscodeSetupScreen extends StatefulWidget {
  const PasscodeSetupScreen({super.key});

  @override
  State<PasscodeSetupScreen> createState() => _PasscodeSetupScreenState();
}

class _PasscodeSetupScreenState extends State<PasscodeSetupScreen> {
  final _lock = AppLockController();

  String _step = 'new'; // new | confirm
  String _first = '';
  String _input = '';
  String? _error;

  void _onDigit(String d) {
    if (_input.length >= 4) return;
    setState(() {
      _input += d;
      _error = null;
    });

    if (_input.length == 4) {
      if (_step == 'new') {
        setState(() {
          _first = _input;
          _input = '';
          _step = 'confirm';
        });
      } else {
        if (_input == _first) {
          _lock.setPasscode(_input);
          Navigator.pop(context, true);
        } else {
          setState(() {
            _error = 'Passcodes do not match.';
            _input = '';
            _step = 'new';
            _first = '';
          });
        }
      }
    }
  }

  void _onBackspace() {
    if (_input.isEmpty) return;
    setState(() {
      _input = _input.substring(0, _input.length - 1);
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _step == 'new' ? 'Set passcode' : 'Confirm passcode';
    final dots = List.generate(4, (i) => i < _input.length);

    return Scaffold(
      appBar: AppBar(title: const Text('Passcode')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final filled in dots)
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 16),
                _PinPad(onDigit: _onDigit, onBackspace: _onBackspace),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinPad extends StatelessWidget {
  final void Function(String d) onDigit;
  final VoidCallback onBackspace;

  const _PinPad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    Widget key(String label, {VoidCallback? onTap}) {
      return SizedBox(
        width: 72,
        height: 56,
        child: OutlinedButton(
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [key('1', onTap: () => onDigit('1')), const SizedBox(width: 10), key('2', onTap: () => onDigit('2')), const SizedBox(width: 10), key('3', onTap: () => onDigit('3'))],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [key('4', onTap: () => onDigit('4')), const SizedBox(width: 10), key('5', onTap: () => onDigit('5')), const SizedBox(width: 10), key('6', onTap: () => onDigit('6'))],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [key('7', onTap: () => onDigit('7')), const SizedBox(width: 10), key('8', onTap: () => onDigit('8')), const SizedBox(width: 10), key('9', onTap: () => onDigit('9'))],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            key(' ', onTap: null),
            const SizedBox(width: 10),
            key('0', onTap: () => onDigit('0')),
            const SizedBox(width: 10),
            SizedBox(
              width: 72,
              height: 56,
              child: OutlinedButton(
                onPressed: onBackspace,
                child: const Icon(Icons.backspace_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
