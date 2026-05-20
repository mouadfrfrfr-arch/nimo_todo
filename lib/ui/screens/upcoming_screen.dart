import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nimo_todo/core/date_utils.dart';
import 'package:nimo_todo/data/models/task.dart';
import 'package:nimo_todo/data/repos/task_repository.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final _repo = TaskRepository();

  Future<List<Task>> _load() => _repo.listUpcomingScheduledTasks();

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
              child: Text('No upcoming tasks.\nAdd a due date to see tasks here.'),
            ),
          );
        }

        final groups = _groupByDay(items);

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final g in groups) ...[
              _DayHeader(label: g.label),
              const SizedBox(height: 8),
              ...g.tasks.map((t) => _TaskRow(
                    task: t,
                    onToggle: _toggleDone,
                    onReschedule: _reschedule,
                  )),
              const SizedBox(height: 16),
            ]
          ],
        );
      },
    );
  }

  List<_DayGroup> _groupByDay(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateUtilsX.startOfDay(now);
    final tomorrow = today.add(const Duration(days: 1));

    final map = <DateTime, List<Task>>{};
    for (final t in tasks) {
      final d = t.dueAt!;
      final key = DateUtilsX.startOfDay(d);
      map.putIfAbsent(key, () => []).add(t);
    }

    final keys = map.keys.toList()..sort();

    return [
      for (final k in keys)
        _DayGroup(
          day: k,
          label: k == today
              ? 'Today'
              : k == tomorrow
                  ? 'Tomorrow'
                  : DateFormat('EEE, MMM d').format(k),
          tasks: map[k]!,
        )
    ];
  }

  Future<void> _toggleDone(Task t, bool isDone) async {
    if (t.id == null) return;
    await _repo.setDone(id: t.id!, isDone: isDone);
    if (mounted) setState(() {});
  }

  Future<void> _reschedule(Task t) async {
    if (t.id == null) return;

    final now = DateTime.now();
    final initial = t.dueAt ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    final due = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime?.hour ?? 9,
      pickedTime?.minute ?? 0,
    );

    await _repo.setDueAt(id: t.id!, dueAt: due);
    if (mounted) setState(() {});
  }
}

class _DayGroup {
  final DateTime day;
  final String label;
  final List<Task> tasks;
  _DayGroup({required this.day, required this.label, required this.tasks});
}

class _DayHeader extends StatelessWidget {
  final String label;
  const _DayHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  final Future<void> Function(Task task, bool isDone) onToggle;
  final Future<void> Function(Task task) onReschedule;

  const _TaskRow({
    required this.task,
    required this.onToggle,
    required this.onReschedule,
  });

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timeLabel != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(timeLabel, style: Theme.of(context).textTheme.labelLarge),
              ),
            IconButton(
              tooltip: 'Reschedule',
              onPressed: () => onReschedule(task),
              icon: const Icon(Icons.edit_calendar_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
