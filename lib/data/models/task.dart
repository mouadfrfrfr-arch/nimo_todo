class Task {
  final int? id;
  final String title;
  final String? notes;
  final DateTime createdAt;
  final DateTime? dueAt;
  final bool isDone;
  final int priority; // 0 none, 1 low, 2 med, 3 high
  final String listId; // Phase 1: 'inbox' default

  const Task({
    this.id,
    required this.title,
    this.notes,
    required this.createdAt,
    this.dueAt,
    required this.isDone,
    required this.priority,
    required this.listId,
  });

  Task copyWith({
    int? id,
    String? title,
    String? notes,
    DateTime? createdAt,
    DateTime? dueAt,
    bool? isDone,
    int? priority,
    String? listId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      listId: listId ?? this.listId,
    );
  }
}
