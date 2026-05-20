import 'package:nimo_todo/core/date_utils.dart';
import 'package:nimo_todo/data/db/app_db.dart';
import 'package:nimo_todo/data/mappers/task_mapper.dart';
import 'package:nimo_todo/data/models/task.dart';

class TaskRepository {
  TaskRepository({AppDb? appDb}) : _appDb = appDb ?? AppDb.instance;
  final AppDb _appDb;

  Future<int> createTask({
    required String title,
    String? notes,
    required String listId,
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
      listId: listId,
    );

    return db.insert('tasks', TaskMapper.toRow(task));
  }

  Future<int> createInboxTask({
    required String title,
    String? notes,
  }) {
    return createTask(title: title, notes: notes, listId: 'inbox');
  }

  Future<List<Task>> listInboxTasks({bool includeDone = false}) {
    return listTasksByList(listId: 'inbox', includeDone: includeDone);
  }

  Future<List<Task>> listTasksByList({
    required String listId,
    bool includeDone = false,
  }) async {
    final db = await _appDb.db;

    final rows = await db.query(
      'tasks',
      where: includeDone ? 'list_id = ?' : 'list_id = ? AND is_done = 0',
      whereArgs: [listId],
      orderBy: 'created_at DESC',
    );

    return rows.map(TaskMapper.fromRow).toList();
  }

  Future<List<Task>> listOverdueTasks({DateTime? now}) async {
    final db = await _appDb.db;
    final n = now ?? DateTime.now();

    final rows = await db.query(
      'tasks',
      where: 'is_done = 0 AND due_at IS NOT NULL AND due_at < ?',
      whereArgs: [n.toIso8601String()],
      orderBy: 'due_at ASC',
    );

    return rows.map(TaskMapper.fromRow).toList();
  }

  Future<List<Task>> listDueTodayTasks({DateTime? now}) async {
    final db = await _appDb.db;
    final n = now ?? DateTime.now();

    final start = DateUtilsX.startOfDay(n);
    final end = DateUtilsX.startOfNextDay(n);

    final rows = await db.query(
      'tasks',
      where: 'is_done = 0 AND due_at IS NOT NULL AND due_at >= ? AND due_at < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'due_at ASC',
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
