import 'package:flutter/material.dart';
import 'package:nimo_todo/data/models/task.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';
import 'package:nimo_todo/ui/widgets/premium_task_tile.dart';
import 'package:nimo_todo/ui/widgets/quick_add_bar.dart';

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

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            Text('Inbox', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Quick capture', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            QuickAddBar(
              listId: 'inbox',
              onAdded: () => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Inbox is empty. Use Quick Add or tap “Add task”.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ...items.map(
              (t) => PremiumTaskTile(
                task: t,
                onToggle: (isDone) async {
                  if (t.id == null) return;
                  await _repo.setDone(id: t.id!, isDone: isDone);
                  if (mounted) setState(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
