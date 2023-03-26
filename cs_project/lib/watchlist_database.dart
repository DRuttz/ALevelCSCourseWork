import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WatchlistDatabase {
  static final WatchlistDatabase instance = WatchlistDatabase._init();

  static Database? _database;

  WatchlistDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'watchlist.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAnime (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT,
        $columnPosterImage TEXT,
        $columnEpisodeCount INTEGER,
        $columnWatchedEpisodes INTEGER
        
      )
    ''');
  }

  Future<int> create(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableAnime, row);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await instance.database;
    return await db.query(tableAnime);
  }

  Future<int> update(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db
        .update(tableAnime, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableAnime, where: '$columnId = ?', whereArgs: [id]);
  }

  static const String tableAnime = 'anime';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnPosterImage = 'poster_image';
  static const String columnEpisodeCount = 'episode_count';
  static const String columnWatchedEpisodes = 'watched_episodes';
}
