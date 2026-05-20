import 'package:flutter/material.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _repo = TaskRepository();
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    try {
      await _repo.createInboxTask(title: title, notes: _notesCtrl.text);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('New task', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton(
                onPressed: _saving ? null : () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'e.g. Buy milk',
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesCtrl,
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.add),
              label: Text(_saving ? 'Saving...' : 'Add to Inbox'),
            ),
          ),
        ],
      ),
    );
  }
}
