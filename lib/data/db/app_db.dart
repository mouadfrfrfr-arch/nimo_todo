import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  static final AppDb instance = AppDb._();
  AppDb._();

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'nimo_todo.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            notes TEXT,
            created_at TEXT NOT NULL,
            due_at TEXT,
            is_done INTEGER NOT NULL,
            priority INTEGER NOT NULL,
            list_id TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE INDEX idx_tasks_list_done_due
          ON tasks(list_id, is_done, due_at);
        ''');
      },
    );

    _db = database;
    return database;
  }
}
