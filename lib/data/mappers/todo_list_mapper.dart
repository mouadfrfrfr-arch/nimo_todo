import 'package:nimo_todo/data/models/todo_list.dart';

class TodoListMapper {
  static Map<String, Object?> toRow(TodoList l) {
    return {
      'id': l.id,
      'name': l.name,
      'sort_order': l.sortOrder,
      'created_at': l.createdAt.toIso8601String(),
    };
  }

  static TodoList fromRow(Map<String, Object?> row) {
    return TodoList(
      id: row['id'] as String,
      name: row['name'] as String,
      sortOrder: row['sort_order'] as int,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
