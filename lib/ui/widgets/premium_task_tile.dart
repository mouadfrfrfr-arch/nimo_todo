import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nimo_todo/data/models/task.dart';

class PremiumTaskTile extends StatelessWidget {
  final Task task;
  final Future<void> Function(bool isDone) onToggle;
  final VoidCallback? onTap;

  const PremiumTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final due = task.dueAt;
    final timeLabel = (due == null) ? null : DateFormat('HH:mm').format(due);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _PremiumCheck(
                value: task.isDone,
                onChanged: (v) => onToggle(v),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            decoration: task.isDone ? TextDecoration.lineThrough : null,
                            color: task.isDone
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.notes != null && task.notes!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]
                  ],
                ),
              ),
              if (timeLabel != null) ...[
                const SizedBox(width: 10),
                _TimePill(label: timeLabel),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String label;
  const _TimePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _PremiumCheck extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PremiumCheck({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? cs.primary : Colors.transparent,
          border: Border.all(color: value ? cs.primary : cs.outline, width: 1.4),
        ),
        child: value
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}
