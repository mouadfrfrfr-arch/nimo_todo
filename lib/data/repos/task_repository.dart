import 'package:nimo_todo/data/db/app_db.dart';
import 'package:nimo_todo/data/mappers/task_mapper.dart';
import 'package:nimo_todo/data/models/task.dart';

class TaskRepository {
  TaskRepository({AppDb? appDb}) : _appDb = appDb ?? AppDb.instance;
  final AppDb _appDb;

  Future<int> createInboxTask({
    required String title,
    String? notes,
  }) async {
    final db = await _appDb.db;
    final now = DateTime.now();

    final task = Task(
      id: null,
      title: title.trim(),
      notes: (notes == null || notes.trim().isEmpty) ? null : notes.trim(),
      createdAt: now,
      dueAt: null,
      isDone: false,
      priority: 0,
      listId: 'inbox',
    );

    return db.insert('tasks', TaskMapper.toRow(task));
  }

  Future<List<Task>> listInboxTasks({bool includeDone = false}) async {
    final db = await _appDb.db;

    final rows = await db.query(
      'tasks',
      where: includeDone ? 'list_id = ?' : 'list_id = ? AND is_done = 0',
      whereArgs: const ['inbox'],
      orderBy: 'created_at DESC',
    );

    return rows.map(TaskMapper.fromRow).toList();
  }

  Future<void> setDone({required int id, required bool isDone}) async {
    final db = await _appDb.db;
    await db.update(
      'tasks',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
