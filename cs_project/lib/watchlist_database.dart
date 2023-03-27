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
      CREATE TABLE $tableAnimeWatching (
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
    return await db.insert(tableAnimeWatching, row);
  } //method to create database

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await instance.database;
    return await db.query(tableAnimeWatching);
  } //method to query the database

  Future<int> update(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(tableAnimeWatching, row,
        where: '$columnId = ?', whereArgs: [id]);
  } //method to update the database

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db
        .delete(tableAnimeWatching, where: '$columnId = ?', whereArgs: [id]);
  } //method to delete items from the database

  static const String tableAnimeWatching = 'anime';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnPosterImage = 'poster_image';
  static const String columnEpisodeCount = 'episode_count';
  static const String columnWatchedEpisodes = 'watched_episodes';
}
