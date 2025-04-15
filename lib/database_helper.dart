import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'quote.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quotes.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quotes(
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        author TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<String> insertQuote(Quote quote) async {
    final db = await database;
    await db.insert('quotes', quote.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
    return quote.id;
  }

  Future<Quote?> getQuote(String id) async {
    final db = await database;
    final maps = await db.query(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Quote>> getAllQuotes() async {
    final db = await database;
    final result = await db.query('quotes', orderBy: 'updatedAt DESC');
    return result.map((map) => Quote.fromMap(map)).toList();
  }

  Future<int> updateQuote(Quote quote) async {
    final db = await database;
    return db.update(
      'quotes',
      quote.toMap(),
      where: 'id = ?',
      whereArgs: [quote.id],
    );
  }

  Future<int> deleteQuote(String id) async {
    final db = await database;
    return await db.delete(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllQuotes() async {
    final db = await database;
    return await db.delete('quotes');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} 