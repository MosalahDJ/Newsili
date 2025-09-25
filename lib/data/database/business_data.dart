import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BusinessData {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'news_database.db'),
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE buisness_news (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            response_data TEXT,
            last_updated TEXT
          )
          ''');
      },
      version: 1,
    );
  }

  Future<void> insertdata(String query, [List<dynamic>? parameters]) async {
    final Database db = await database;
    try {
      await db.rawInsert(query, parameters);
    } catch (e) {
      print('Database insertion error: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> readdata(String query) async {
    final Database db = await database;
    return await db.rawQuery(query);
  }
}

