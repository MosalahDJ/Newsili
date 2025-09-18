import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EntertainmentData {
  static final EntertainmentData instance = EntertainmentData._init();
  static Database? _database;

  EntertainmentData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('entertainment_news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entertainment_news(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        timestamp INTEGER
      )
    ''');
  }

  Future<void> insertNews(List<Map<String, dynamic>> articles) async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear old data
      await txn.delete('entertainment_news');

      // Insert new articles
      for (var article in articles) {
        await txn.insert('entertainment_news', {
          ...article,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getNews() async {
    final db = await database;
    return await db.query('entertainment_news', orderBy: 'timestamp DESC');
  }

  Future<void> deleteOldNews() async {
    final db = await database;
    final oneHourAgo = DateTime.now()
        .subtract(const Duration(hours: 1))
        .millisecondsSinceEpoch;
    await db.delete(
      'entertainment_news',
      where: 'timestamp < ?',
      whereArgs: [oneHourAgo],
    );
  }
}
