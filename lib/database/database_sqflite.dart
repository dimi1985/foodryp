import 'package:foodryp/database/database_interface';
import 'package:foodryp/models/celebration_day.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseSqflite implements DatabaseInterface {
  static const _databaseName = 'celebration_database.db';
  static const _databaseVersion = 1;
  static const table = 'celebrations';
  
  static const columnId = 'id';
  static const columnDescription = 'description';
  static const columnDueDate = 'dueDate';

  static Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) return;
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);
    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDescription TEXT NOT NULL,
        $columnDueDate TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<int> insertCelebration(CelebrationDay celebration) async {
    Database db = await database;
    return await db.insert(table, celebration.toMap());
  }

  @override
  Future<List<CelebrationDay>> queryAllCelebrations() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return CelebrationDay.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateCelebration(CelebrationDay celebration) async {
    Database db = await database;
    return await db.update(table, celebration.toMap(), where: '$columnId = ?', whereArgs: [celebration.id]);
  }

  @override
  Future<int> deleteCelebration(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await init(); // Ensure database is initialized
    return _database!;
  }
}
