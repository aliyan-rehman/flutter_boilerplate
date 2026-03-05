import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class SqliteService {
  // Single database instance — we don't want to open DB multiple times
  static Database? _database;

  // Getter — if DB already open return it, otherwise open it
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize (open/create) the database
  Future<Database> _initDatabase() async {
    // Get the path where database file will be stored on device
    String path = join(await getDatabasesPath(), 'items.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable, // called only first time when DB is created
    );
  }

  // Create the items table
  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');
  }

  // ADD item
  Future<void> addItem(ItemModel item) async {
    final db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // GET all items
  Future<List<ItemModel>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    // Convert each row Map → ItemModel
    return maps.map((map) => ItemModel.fromMap(map)).toList();
  }

  // UPDATE item
  Future<void> updateItem(ItemModel item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',       // find row where id matches
      whereArgs: [item.id],  // the id value to match
    );
  }

  // DELETE item
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}