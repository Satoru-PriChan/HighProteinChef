import 'package:high_protein_chef/models/recipe.dart';
import 'package:high_protein_chef/services/logger.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:high_protein_chef/entities/recipe_entity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const String tableFavorites = "favorites";

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        imageUrl TEXT,
        ingredients TEXT,
        instructions TEXT,
        calories REAL,
        protein REAL,
        fat REAL
      )
    ''');
  }

  Future<void> insertRecipe(RecipeEntity entity) async {
    final db = await database;
    int id = await db.insert(
      tableFavorites, 
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    logger.d("id: ${id}");
  }

  Future<List<RecipeEntity>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableFavorites);
    final result = List.generate(maps.length, (i) => RecipeEntity.fromMap(maps[i]));
    logger.d("maps: ${maps.toString()}");
    logger.d("result: ${result.toString()}");
    return result;
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    int deletedCount = await db.delete(
      tableFavorites,
      where: 'id = ?',
      whereArgs: [id]
    );
    logger.d("deletedCount: ${deletedCount}");
  }
}