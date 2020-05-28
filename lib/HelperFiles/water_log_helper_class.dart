import 'dart:io';
import 'package:sleep_tracker/model/water_log_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class WaterLogDatabaseHelper {
  WaterLogDatabaseHelper._();

  static final WaterLogDatabaseHelper db = WaterLogDatabaseHelper._();
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
    String path = join(documentsDirectory.path, "WaterLog.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE WaterLog (id INTEGER PRIMARY KEY,day INTEGER,month INTEGER,year INTEGER,drank INTEGER)');
        });
  }

  Future<void> insertWaterValInLog(WaterLogData waterLog) async {
    final db = await database;
    var res = await db.insert("WaterLog", waterLog.toMap());
    return res;
  }

  getAllWaterLog() async {
    final db = await database;
    var res = await db.query("WaterLog",orderBy: 'id DESC');
    List<WaterLogData> list =
    res.isNotEmpty ? res.map((c) => WaterLogData.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Map<String, dynamic>>> getValueForGraph() async {
    final db = await database;
    var res = await db.query("WaterLog", orderBy: 'id DESC',limit: 7);
    return res;
  }

  deleteAll() async {
    final db = await database;
    db.rawQuery('DELETE FROM WaterLog');
  }

  deleteOneWaterLog(int id) async {
    final db = await database;
    db.delete('WaterLog', where: 'id=?', whereArgs: [id]);
  }


  Future<void> updateWaterLog(WaterLogData data) async {
    final db = await database;
    var res = await db
        .update('Waterlog', data.toMap(), where: 'id=?', whereArgs: [data.id]);
    return res;
  }


}
