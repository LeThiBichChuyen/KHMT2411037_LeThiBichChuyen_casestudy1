
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expense_manager.db');
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
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  // Lấy tất cả giao dịch, giao dịch mới nhất hiển thị trước
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await instance.database;

    return await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );
  }

  // Thêm giao dịch mới
  Future<int> insertTransaction(Map<String, dynamic> data) async {
    final db = await instance.database;

    return await db.insert('transactions', data);
  }

  // Cập nhật giao dịch
  Future<int> updateTransaction(
      int id,
      Map<String, dynamic> data,
      ) async {
    final db = await instance.database;

    return await db.update(
      'transactions',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Xóa giao dịch
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
