import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Database নাম এবং version
  static const String DB_NAME = "task_manager.db";
  static const int DB_VERSION = 1;

  // টেবিল এবং কলাম ডিফাইন
  static const String TABLE_TASK = "tasks";
  static const String COL_ID = "id";
  static const String COL_TITLE = "title";
  static const String COL_DESCRIPTION = "description";
  static const String COL_STATUS = "status";
  static const String COL_CREATED_DATE = "createdDate";

  // Database instance পাওয়া
  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Database initialize
  static Future<Database> _initDb() async {
    String dbPath = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(
      dbPath,
      version: DB_VERSION,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $TABLE_TASK(
            $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_TITLE TEXT,
            $COL_DESCRIPTION TEXT,
            $COL_STATUS TEXT,
            $COL_CREATED_DATE TEXT
          )
        ''');
      },
    );
  }

  // Data insert
  static Future<int> insertTask(Map<String, dynamic> row) async {
    final db = await getDb();
    return await db.insert(TABLE_TASK, row);
  }

  // Data read
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await getDb();
    return await db.query(TABLE_TASK, orderBy: "$COL_CREATED_DATE DESC");
  }

  // Update
  static Future<int> updateTask(Map<String, dynamic> row) async {
    final db = await getDb();
    int id = row[COL_ID];
    return await db.update(TABLE_TASK, row, where: "$COL_ID = ?", whereArgs: [id]);
  }

  // Delete
  static Future<int> deleteTask(int id) async {
    final db = await getDb();
    return await db.delete(TABLE_TASK, where: "$COL_ID = ?", whereArgs: [id]);
  }
}
