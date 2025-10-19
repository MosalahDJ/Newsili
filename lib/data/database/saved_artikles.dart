import 'package:newsily/data/models/news_data_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SavedArtikles {
  static Database? _database;

  // Singleton pattern
  static final SavedArtikles instance = SavedArtikles._internal();
  SavedArtikles._internal();

  factory SavedArtikles() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'saved_artikles.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE saved_artikles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            article_id TEXT UNIQUE,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            source TEXT,
            publishedAt TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  // 🟢 Save article (as a map)
  Future<void> saveArticle(Articles article) async {
    final db = await database;
    try {
      //TODO: schould I fix the problem hier  I must have a list of Articles
      await db.insert(
        'saved_artikles',
        {
          'article_id': article.url, // fallback
          'title': article.title,
          'description': article.description,
          'imageUrl': article.urlToImage,
          'source': article.source?.name??article.source,
          'publishedAt': article.publishedAt,
          'content': article.content,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error saving article: $e');
    }
  }

  // 🔴 Remove article
  Future<void> removeArticle(String articleId) async {
    final db = await database;
    await db.delete(
      'saved_artikles',
      where: 'article_id = ?',
      whereArgs: [articleId],
    );
  }

  // 📖 Get all saved articles
  Future<List<Map<String, dynamic>>> getAllSavedArticles() async {
    final db = await database;
    return await db.query('saved_artikles', orderBy: 'id DESC');
  }

  // 🔍 Check if an article is already saved
  Future<bool> isArticleSaved(String articleId) async {
    final db = await database;
    final result = await db.query(
      'saved_artikles',
      where: 'article_id = ?',
      whereArgs: [articleId],
    );
    return result.isNotEmpty;
  }
}
