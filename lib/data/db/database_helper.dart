import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/utils/constants.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            status TEXT,
            dueDate TEXT,
            createdAt TEXT,
            priority TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN createdAt TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN priority TEXT');
        }
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks({
    SortType sortType = SortType.asc,
    SortOptions sortOption = SortOptions.createDate,
  }) async {
    final db = await database;
    String orderBy;

    switch (sortOption) {
      case SortOptions.createDate:
        orderBy = "createdAt ${sortType == SortType.asc ? 'ASC' : 'DESC'}";
        break;

      case SortOptions.dueDate:
        orderBy = "dueDate ${sortType == SortType.asc ? 'ASC' : 'DESC'}";
        break;

      case SortOptions.priority:
        orderBy = '''
        CASE priority
          WHEN '${PriorityType.high.name}' THEN 1
          WHEN '${PriorityType.medium.name}' THEN 2
          WHEN '${PriorityType.low.name}' THEN 3
          ELSE 4
        END ${sortType == SortType.asc ? 'ASC' : 'DESC'}
      ''';
        break;
      case SortOptions.none:
        orderBy = "createdAt ASC";
      break;
    }

    final List<Map<String, dynamic>> maps =
        await db.query('tasks', orderBy: orderBy);

    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
