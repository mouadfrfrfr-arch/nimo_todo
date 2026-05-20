import 'package:flutter/material.dart';
import 'package:nimo_todo/data/models/task.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final _repo = TaskRepository();

  Future<List<Task>> _load() => _repo.listInboxTasks(includeDone: false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snap.data ?? const <Task>[];

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Inbox is empty.\nTap “Add task” to capture something quickly.'),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final t = items[i];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: t.isDone,
                  onChanged: (v) async {
                    if (t.id == null) return;
                    await _repo.setDone(id: t.id!, isDone: v ?? false);
                    if (mounted) setState(() {});
                  },
                ),
                title: Text(t.title),
                subtitle: (t.notes == null) ? null : Text(t.notes!),
              ),
            );
          },
        );
      },
    );
  }
}
