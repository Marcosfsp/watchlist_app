import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'anime.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'watchlist.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE watchlist(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            imageUrl TEXT
          )
          '''
        );
      },
    );
  }

  // Função para adicionar um anime à watchlist
  Future<int> insertAnime(Anime anime) async {
    final db = await database;
    return await db.insert('watchlist', anime.toMap());
  }

  // Função para buscar todos os animes na watchlist
  Future<List<Anime>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('watchlist');

    return List.generate(maps.length, (i) {
      return Anime.fromMap(maps[i]);
    });
  }

  // Função para deletar um anime da watchlist
  Future<int> deleteAnime(int id) async {
    final db = await database;
    return await db.delete(
      'watchlist',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
