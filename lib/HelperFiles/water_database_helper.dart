import 'dart:io';
import 'package:sleep_tracker/model/water_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class WaterDatabaseHelper {
  WaterDatabaseHelper._();

  static final WaterDatabaseHelper db = WaterDatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WaterToday.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE WaterToday (id INTEGER PRIMARY KEY,time TEXT,drank INTEGER)');
        });
  }

  Future<void> insertWaterVal(Water water) async {
    final db = await database;
    var res = await db.insert("WaterToday", water.toMap());
    return res;
  }

  getAllWater() async {
    final db = await database;
    var res = await db.query("WaterToday",orderBy: 'id DESC');
    List<Water> list =
    res.isNotEmpty ? res.map((c) => Water.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Map<String, dynamic>>> getValueForGraph() async {
    final db = await database;
    var res = await db.query("WaterToday",orderBy: 'id DESC');
    return res;
  }

  deleteOneWaterLog(int id) async {
    final db = await database;
    db.delete('WaterToday', where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await database;
    db.rawQuery('DELETE FROM WaterToday');
  }
}
