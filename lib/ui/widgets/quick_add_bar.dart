import 'package:flutter/material.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';
import 'package:nimo_todo/quick_add/quick_add_parser.dart';

class QuickAddBar extends StatefulWidget {
  final String listId;
  final VoidCallback onAdded;

  const QuickAddBar({
    super.key,
    required this.listId,
    required this.onAdded,
  });

  @override
  State<QuickAddBar> createState() => _QuickAddBarState();
}

class _QuickAddBarState extends State<QuickAddBar> {
  final _ctrl = TextEditingController();
  final _repo = TaskRepository();
  bool _saving = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _ctrl.text.trim();
    if (raw.isEmpty) return;

    final parsed = QuickAddParser.parse(raw);

    setState(() => _saving = true);
    try {
      await _repo.createTaskFromQuickAdd(
        listId: widget.listId,
        title: parsed.title,
        dueAt: parsed.dueAt,
        remindMinutesBefore: parsed.remindMinutesBefore,
      );
      _ctrl.clear();
      widget.onAdded();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            enabled: !_saving,
            decoration: const InputDecoration(
              hintText: 'Quick add: "Pay rent tomorrow 9am rm 30m"',
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? '...' : 'Add'),
        ),
      ],
    );
  }
}
