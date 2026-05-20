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
    return FutureBuilder<({List<Task> overdue, List<Task> dueToday})>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snap.data;
        final overdue = data?.overdue ?? const <Task>[];
        final dueToday = data?.dueToday ?? const <Task>[];

        if (overdue.isEmpty && dueToday.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nothing scheduled for today yet.\nAdd a due date to see tasks here.'),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (overdue.isNotEmpty) ...[
              _SectionHeader(title: 'Overdue', tone: _HeaderTone.danger),
              const SizedBox(height: 8),
              ...overdue.map((t) => _TaskRow(task: t, onToggle: _toggleDone)),
              const SizedBox(height: 16),
            ],
            if (dueToday.isNotEmpty) ...[
              const _SectionHeader(title: 'Due today', tone: _HeaderTone.normal),
              const SizedBox(height: 8),
              ...dueToday.map((t) => _TaskRow(task: t, onToggle: _toggleDone)),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  final Future<void> Function(Task task, bool isDone) onToggle;

  const _TaskRow({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final due = task.dueAt;
    final dueLabel = (due == null) ? null : DateFormat('HH:mm').format(due);

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (v) => onToggle(task, v ?? false),
        ),
        title: Text(task.title),
        subtitle: task.notes == null ? null : Text(task.notes!),
        trailing: dueLabel == null
            ? null
            : Text(
                dueLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
      ),
    );
  }
}
