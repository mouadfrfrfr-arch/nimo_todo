import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nimo_todo/data/models/task.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _repo = TaskRepository();

  Future<({List<Task> overdue, List<Task> dueToday})> _load() async {
    final overdue = await _repo.listOverdueTasks();
    final dueToday = await _repo.listDueTodayTasks();
    return (overdue: overdue, dueToday: dueToday);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d').format(DateTime.now());

    return FutureBuilder<({List<Task> overdue, List<Task> dueToday})>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final overdue = snap.data?.overdue ?? const <Task>[];
        final dueToday = snap.data?.dueToday ?? const <Task>[];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            Text('Today', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(dateLabel, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            if (overdue.isEmpty && dueToday.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('All clear', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        'Add a due date to see tasks here.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            if (overdue.isNotEmpty) ...[
              _SectionHeader(title: 'Overdue', tone: _HeaderTone.danger),
              const SizedBox(height: 10),
              ...overdue.map((t) => _TaskTile(task: t, onToggle: _toggleDone)),
              const SizedBox(height: 18),
            ],
            if (dueToday.isNotEmpty) ...[
              const _SectionHeader(title: 'Due today', tone: _HeaderTone.normal),
              const SizedBox(height: 10),
              ...dueToday.map((t) => _TaskTile(task: t, onToggle: _toggleDone)),
            ],
          ],
        );
      },
    );
  }

  Future<void> _toggleDone(Task t, bool isDone) async {
    if (t.id == null) return;
    await _repo.setDone(id: t.id!, isDone: isDone);
    if (mounted) setState(() {});
  }
}

enum _HeaderTone { normal, danger }

class _SectionHeader extends StatelessWidget {
  final String title;
  final _HeaderTone tone;
  const _SectionHeader({required this.title, required this.tone});

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      _HeaderTone.normal => Theme.of(context).colorScheme.primary,
      _HeaderTone.danger => Theme.of(context).colorScheme.error,
    };

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final Future<void> Function(Task t, bool isDone) onToggle;
  const _TaskTile({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final due = task.dueAt;
    final timeLabel = (due == null) ? null : DateFormat('HH:mm').format(due);

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (v) => onToggle(task, v ?? false),
        ),
        title: Text(task.title),
        subtitle: task.notes == null ? null : Text(task.notes!),
        trailing: timeLabel == null
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Text(timeLabel, style: Theme.of(context).textTheme.labelLarge),
              ),
      ),
    );
  }
}
