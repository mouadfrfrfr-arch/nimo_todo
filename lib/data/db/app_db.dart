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
      version: 2,
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

        await db.execute('''
          CREATE TABLE lists (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            sort_order INTEGER NOT NULL,
            created_at TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE INDEX idx_lists_sort
          ON lists(sort_order);
        ''');

        // Default Inbox list
        await db.insert('lists', {
          'id': 'inbox',
          'name': 'Inbox',
          'sort_order': 0,
          'created_at': DateTime.now().toIso8601String(),
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE lists (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              sort_order INTEGER NOT NULL,
              created_at TEXT NOT NULL
            );
          ''');

          await db.execute('''
            CREATE INDEX idx_lists_sort
            ON lists(sort_order);
          ''');

          // Default Inbox list
          await db.insert('lists', {
            'id': 'inbox',
            'name': 'Inbox',
            'sort_order': 0,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      },
    );

    _db = database;
    return database;
  }
}
