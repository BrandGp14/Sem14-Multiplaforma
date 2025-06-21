import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'product_model.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._internal();
  static Database? _database;
  ProductDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL'; // Para números decimales (double)

    await db.execute('''
      CREATE TABLE ${ProductFields.tableName} (
        ${ProductFields.id} $idType,
        ${ProductFields.description} $textType,
        ${ProductFields.price} $realType,
        ${ProductFields.isAvailable} $boolType,
        ${ProductFields.createdTime} $textType
      )
    ''');
  }

  Future<ProductModel> create(ProductModel product) async {
    final db = await instance.database;
    final id = await db.insert(ProductFields.tableName, product.toJson());
    return product.copy(id: id);
  }

  Future<ProductModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      ProductFields.tableName,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ProductModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ProductModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(ProductFields.tableName,
        orderBy: '${ProductFields.createdTime} DESC');
    return result.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<int> update(ProductModel product) async {
    final db = await instance.database;
    return db.update(
      ProductFields.tableName,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      ProductFields.tableName,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}