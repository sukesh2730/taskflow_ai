import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('taskflow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT DEFAULT 'General',
        priority INTEGER DEFAULT 3,
        energy_req INTEGER DEFAULT 3,
        estimated_minutes INTEGER DEFAULT 30,
        is_completed INTEGER DEFAULT 0,
        project_id INTEGER,
        due_date TEXT,
        completed_at TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Projects table
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        unlocked_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // User logs table
    await db.execute('''
      CREATE TABLE user_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        energy_level INTEGER NOT NULL,
        mood TEXT NOT NULL,
        logged_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert default achievements
    await db.insert('achievements', {
      'name': 'The Starter',
      'description': 'Complete your first task',
      'icon': '🌱',
      'unlocked_at': null,
    });

    await db.insert('achievements', {
      'name': 'Productivity Master',
      'description': 'Complete 10 tasks',
      'icon': '🚀',
      'unlocked_at': null,
    });

    await db.insert('achievements', {
      'name': 'Streak Keeper',
      'description': 'Complete tasks 7 days in a row',
      'icon': '🔥',
      'unlocked_at': null,
    });

    await db.insert('achievements', {
      'name': 'Zen Master',
      'description': 'Maintain low stress for 30 days',
      'icon': '🧘',
      'unlocked_at': null,
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
