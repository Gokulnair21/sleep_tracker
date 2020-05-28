import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sleep_tracker/model/sleep_log_save.dart';

class SleepDatabaseHelper {
  SleepDatabaseHelper._();

  static final SleepDatabaseHelper db = SleepDatabaseHelper._();
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
    String path = join(documentsDirectory.path, "Sleeplog.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Sleeplog (id INTEGER PRIMARY KEY,day TEXT, month TEXT, year TEXT,hour TEXT,minute TEXT,slept REAL )');
    });
  }

  Future<void> insertSleepVal(Sleep sleep) async {
    final db = await database;
    var res = await db.insert("Sleeplog", sleep.toMap());
    return res;
  }

  getAllSleep() async {
    final db = await database;
    var res = await db.query("Sleeplog",orderBy: 'id DESC');
    List<Sleep> list =
        res.isNotEmpty ? res.map((c) => Sleep.fromMap(c)).toList() : [];
    return list;
  }

  deleteOneSleepLog(int id) async {
    final db = await database;
    db.delete('Sleeplog', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTopTenValues() async {
    final db = await database;
    var res = await db.query("Sleeplog", limit: 10,orderBy: 'id DESC');
    return res;
  }

  getMinValue() async {
    final db = await database;

    var res = await db.rawQuery(
        'SELECT * FROM Sleeplog WHERE slept = (SELECT MIN(slept)FROM Sleeplog )');
    return res.isNotEmpty ? Sleep.fromMap(res.first) : Null;
  }

  getAvgSleptValue() async {
    final db = await database;

    var res = await db.rawQuery(
        'SELECT AVG(slept) FROM Sleeplog ');
    return res.toString();
  }

  getMaxValue() async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM Sleeplog WHERE slept = (SELECT MAX(slept)FROM Sleeplog )');
    return res.isNotEmpty ? Sleep.fromMap(res.first) : Null;
  }

  deleteAll() async {
    final db = await database;
    db.rawQuery('DELETE FROM Sleeplog');
  }
}
