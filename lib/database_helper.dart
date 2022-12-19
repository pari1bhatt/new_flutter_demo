import 'dart:io';
import 'package:new_flutter_demo/data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'dataTable';

  static const columnId = 'id';
  static const columnOrderId = 'orderId';
  static const columnOrderType = 'orderType';
  static const columnSequenceNo = 'sequenceNo';
  static const columnExpectedDate = 'expectedDate';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      print('error : $e');
    }
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnOrderId TEXT NOT NULL,
            $columnOrderType TEXT NOT NULL,
            $columnSequenceNo TEXT NOT NULL,
            $columnExpectedDate TEXT NOT NULL
          )
          ''');
  }

  insert(Order order) async {
    Database db = await instance.database;

    await db.insert(table, order.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  queryAll() async {
    Database db = await instance.database;

    // Query the table for all
    final List<Map<String, dynamic>> maps = await db.query(table);
    print("queryAll : ${maps}");
  }

  deleteAll() async {
    Database db = await instance.database;
    db.delete(table);
  }
}
