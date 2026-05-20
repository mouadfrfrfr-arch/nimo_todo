import 'package:nimo_todo/data/models/task.dart';

class TaskMapper {
  static Map<String, Object?> toRow(Task t) {
    return {
      'id': t.id,
      'title': t.title,
      'notes': t.notes,
      'created_at': t.createdAt.toIso8601String(),
      'due_at': t.dueAt?.toIso8601String(),
      'reminder_at': t.reminderAt?.toIso8601String(),
      'is_done': t.isDone ? 1 : 0,
      'priority': t.priority,
      'list_id': t.listId,
    };
  }

  static Task fromRow(Map<String, Object?> row) {
    DateTime? parseDate(Object? v) => v == null ? null : DateTime.parse(v as String);

    return Task(
      id: row['id'] as int?,
      title: row['title'] as String,
      notes: row['notes'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      dueAt: parseDate(row['due_at']),
      reminderAt: parseDate(row['reminder_at']),
      isDone: (row['is_done'] as int) == 1,
      priority: row['priority'] as int,
      listId: row['list_id'] as String,
    );
  }
}
