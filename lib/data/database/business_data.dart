import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BusinessData {
  static final BusinessData instance = BusinessData._init();
  static Database? _database;

  BusinessData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('business_news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE business_news(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT,
      timestamp INTEGER
    )
  ''');
  }

  Future<void> insertNews(Map articles) async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear old data
      await txn.delete('business_news');

      // Insert new articles
      
        await txn.insert('business_news', {
          'content': articles,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Map>> getNews() async {
    final db = await database;
    return await db.query('business_news', orderBy: 'timestamp DESC');
  }

  Future<void> deleteOldNews() async {
    final db = await database;
    final oneHourAgo = DateTime.now()
        .subtract(const Duration(hours: 1))
        .millisecondsSinceEpoch;
    await db.delete(
      'business_news',
      where: 'timestamp < ?',
      whereArgs: [oneHourAgo],
    );
  }
}
