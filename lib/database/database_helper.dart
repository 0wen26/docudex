//lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/document.dart';
import '../data/models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'docudex.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      colorHex TEXT NOT NULL,
      iconName TEXT NOT NULL
    );''');

    await db.execute('''CREATE TABLE documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      categoryId INTEGER NOT NULL,
      locationRoom TEXT NOT NULL,
      locationArea TEXT NOT NULL,
      locationBox TEXT NOT NULL,
      note TEXT,
      nfcId TEXT,
      imagePath TEXT,
      referenceNumber TEXT,
      isPrivate INTEGER DEFAULT 0,
      date TEXT,
      reminderDays INTEGER,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id)
    );''');

    await db.execute('''CREATE TABLE locations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      value TEXT NOT NULL
    );''');
  }

  Future<int> insertDocument(Document doc) async {
    final db = await database;
    return await db.insert('documents', doc.toMap());
  }

  Future<List<Document>> getDocuments() async {
    final db = await database;
    final maps = await db.query('documents');
    return maps.map((map) => Document.fromMap(map)).toList();
  }

  Future<int> updateDocument(Document doc) async {
    final db = await database;
    return await db.update(
      'documents',
      doc.toMap(),
      where: 'id = ?',
      whereArgs: [doc.id],
    );
  }

  Future<int> deleteDocument(int id) async {
    final db = await database;
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCategory(Category cat) async {
    final db = await database;
    return await db.insert('categories', cat.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> updateCategory(Category cat) async {
    final db = await database;
    return await db.update(
      'categories',
      cat.toMap(),
      where: 'id = ?',
      whereArgs: [cat.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertLocation(String type, String value) async {
    final db = await database;
    await db.insert('locations', {'type': type, 'value': value});
  }

  Future<List<String>> getLocationValues(String type) async {
    final db = await database;
    final maps = await db.query(
      'locations',
      where: 'type = ?',
      whereArgs: [type],
      distinct: true,
    );
    return maps.map((map) => map['value'] as String).toList();
  }
}
