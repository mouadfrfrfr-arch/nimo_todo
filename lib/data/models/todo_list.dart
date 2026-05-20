class TodoList {
  final String id;
  final String name;
  final int sortOrder;
  final DateTime createdAt;

  const TodoList({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
  });
}
