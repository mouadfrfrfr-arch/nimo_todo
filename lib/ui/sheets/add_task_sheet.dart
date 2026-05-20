import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTime? _dueDate; // date-only anchor
  TimeOfDay? _dueTime; // optional

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  DateTime? _composeDueAt() {
    if (_dueDate == null) return null;
    final d = _dueDate!;
    final t = _dueTime;
    if (t == null) {
      // Default to 09:00 for a better "Today" ordering
      return DateTime(d.year, d.month, d.day, 9, 0);
    }
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
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
        dueAt: _composeDueAt(),
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
              const SizedBox(height: 12),
              _DuePickerRow(
                dueDate: _dueDate,
                dueTime: _dueTime,
                enabled: !_saving,
                onPickDate: () async {
                  final now = DateTime.now();
                  final initial = _dueDate ?? DateTime(now.year, now.month, now.day);

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initial,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 5),
                  );

                  if (picked == null) return;
                  setState(() => _dueDate = DateTime(picked.year, picked.month, picked.day));
                },
                onPickTime: () async {
                  if (_dueDate == null) {
                    // If user picks time first, select today.
                    final now = DateTime.now();
                    setState(() => _dueDate = DateTime(now.year, now.month, now.day));
                  }

                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _dueTime ?? const TimeOfDay(hour: 9, minute: 0),
                  );

                  if (picked == null) return;
                  setState(() => _dueTime = picked);
                },
                onClear: () {
                  setState(() {
                    _dueDate = null;
                    _dueTime = null;
                  });
                },
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

class _DuePickerRow extends StatelessWidget {
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final bool enabled;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onClear;

  const _DuePickerRow({
    required this.dueDate,
    required this.dueTime,
    required this.enabled,
    required this.onPickDate,
    required this.onPickTime,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = (dueDate == null) ? 'No due date' : DateFormat('EEE, MMM d').format(dueDate!);
    final timeLabel = (dueTime == null) ? 'Any time' : dueTime!.format(context);

    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Due'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateLabel, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(timeLabel, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: enabled ? onPickDate : null,
            icon: const Icon(Icons.date_range),
            label: const Text('Date'),
          ),
          const SizedBox(width: 6),
          TextButton.icon(
            onPressed: enabled ? onPickTime : null,
            icon: const Icon(Icons.schedule),
            label: const Text('Time'),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Clear',
            onPressed: (enabled && dueDate != null) ? onClear : null,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
