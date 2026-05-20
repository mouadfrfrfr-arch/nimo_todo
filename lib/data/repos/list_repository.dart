import 'dart:math';

import 'package:nimo_todo/data/db/app_db.dart';
import 'package:nimo_todo/data/mappers/todo_list_mapper.dart';
import 'package:nimo_todo/data/models/todo_list.dart';

class ListRepository {
  ListRepository({AppDb? appDb}) : _appDb = appDb ?? AppDb.instance;
  final AppDb _appDb;

  Future<List<TodoList>> listAll() async {
    final db = await _appDb.db;
    final rows = await db.query('lists', orderBy: 'sort_order ASC');
    return rows.map(TodoListMapper.fromRow).toList();
  }

  Future<void> createList({required String name}) async {
    final db = await _appDb.db;

    final clean = name.trim();
    if (clean.isEmpty) return;

    final maxSortRow = await db.rawQuery('SELECT MAX(sort_order) as m FROM lists');
    final maxSort = (maxSortRow.first['m'] as int?) ?? 0;

    final id = _makeId();
    final list = TodoList(
      id: id,
      name: clean,
      sortOrder: maxSort + 1,
      createdAt: DateTime.now(),
    );

    await db.insert('lists', TodoListMapper.toRow(list));
  }

  Future<void> renameList({required String id, required String name}) async {
    final db = await _appDb.db;
    final clean = name.trim();
    if (clean.isEmpty) return;

    await db.update('lists', {'name': clean}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteList({required String id}) async {
    // Protect Inbox
    if (id == 'inbox') return;

    final db = await _appDb.db;

    // Move tasks to Inbox before deleting list
    await db.update('tasks', {'list_id': 'inbox'}, where: 'list_id = ?', whereArgs: [id]);

    await db.delete('lists', where: 'id = ?', whereArgs: [id]);
  }

  String _makeId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(10, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
