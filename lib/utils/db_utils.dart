import 'package:expirationdate_reminder/ctrls/RefrigeratorController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:expirationdate_reminder/utils/global_utils.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUtils {
  DBUtils._privateConstructor();
  static final DBUtils instance = DBUtils._privateConstructor();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _open();
    return _db!;
  }

  Future _open() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'reminder.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS refrigerator (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      favorites INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS food (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      r_id INTEGER NOT NULL,
      path TEXT NOT NULL,
      name TEXT NOT NULL,
      storage TEXT NOT NULL,
      count INTEGER,
      expiration INTEGER NOT NULL,
      memo TEXT,
      FOREIGN KEY(r_id) REFERENCES refrigerator(id)
    )
  ''');
  }

  Future addRefrigerator(Refrigerator item) async {
    Database db = await instance.db;
    await db.insert(
      'refrigerator', // table name
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future updateRefrigerator(Refrigerator item) async {
    Database db = await instance.db;
    await db.update(
      'refrigerator', // table n
      item.toMap(), // new post row data post row data
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future selectRefrigerator() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query('refrigerator');

    return List.generate(
        maps.length,
            (index) => Refrigerator(
          id: maps[index]['id'] as int,
          name: maps[index]['name'] as String,
          favorites: maps[index]['favorites'] as int,
        ));
  }

  Future addFood(Food item) async {
    Database db = await instance.db;
    int id = await db.insert(
      'food', // table name
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future findFoodById(int rId) async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query('food',
        columns: ['id', 'path', 'name', 'storage', 'count', 'expiration', 'memo', 'r_id'], where: 'r_id = ?', whereArgs: [rId]);

    return List.generate(
        maps.length,
        (index) => Food(
              id: maps[index]['id'] as int,
              path: maps[index]['path'] as String,
              name: maps[index]['name'] as String,
              storage: maps[index]['storage'] as String,
              count: maps[index]['count'] as int,
              expiration: maps[index]['expiration'] as int,
              memo: maps[index]['memo'] as String?,
              rId: maps[index]['r_id'] as int,
            ));
  }

  Future updateFood(Food item) async {
    Database db = await instance.db;
    await db.update(
      'food', // table n
      item.toMap(), // new post row data post row data
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> removeFood(int id) async {
    Database db = await instance.db;
    await db.delete(
      'food', // table name
      where: 'id = ?',
      whereArgs: [id],
    );

    notification.removeNotification(id);

    return id;
  }

  Future removeFoods(List ids) async {
    Database db = await instance.db;
    String where = 'id IN (${List.filled(ids.length, '?').join(',')})';

    await db
        .delete(
      'food', // table name
      where: where,
      whereArgs: ids,
    )
        .whenComplete(() async {
      notification.removeNotifications(ids);
    });
  }

  Future close() async {
    Database db = await instance.db;
    db.close();
  }
}
