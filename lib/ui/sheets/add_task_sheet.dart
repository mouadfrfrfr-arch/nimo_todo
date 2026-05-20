import 'package:flutter/material.dart';
import 'package:nimo_todo/data/models/todo_list.dart';
import 'package:nimo_todo/data/repos/list_repository.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final _taskRepo = TaskRepository();
  final _listRepo = ListRepository();

  bool _saving = false;
  String _selectedListId = 'inbox';

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
      await _taskRepo.createTask(
        title: title,
        notes: _notesCtrl.text,
        listId: _selectedListId,
      );
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return FutureBuilder<List<TodoList>>(
      future: _listRepo.listAll(),
      builder: (context, snap) {
        final lists = snap.data ?? const <TodoList>[];

        // Keep selection valid if lists just loaded
        if (lists.isNotEmpty && !lists.any((l) => l.id == _selectedListId)) {
          _selectedListId = lists.first.id;
        }

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
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'List'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedListId,
                    isExpanded: true,
                    items: lists
                        .map((l) => DropdownMenuItem(
                              value: l.id,
                              child: Text(l.name),
                            ))
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (v) {
                            if (v == null) return;
                            setState(() => _selectedListId = v);
                          },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: (_saving || lists.isEmpty) ? null : _save,
                  icon: const Icon(Icons.add),
                  label: Text(_saving ? 'Saving...' : 'Add task'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
