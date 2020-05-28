import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sleep_tracker/model/alarm.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  static Database _database;

  Future<Database> get databse async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Alarm.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Alarm (id INTEGER PRIMARY KEY AUTOINCREMENT, hour TEXT, minute TEXT, period TEXT,label TEXT,status BIT )');
    });
  }

  getAlarm(int id) async {
    final db = await databse;
    var res = await db.query("Alarm", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Alarm.fromMap(res.first) : Null;
  }

  Future<void> insertAlarm(Alarm newAlarm) async {
    final db = await databse;
    var res = await db.insert("Alarm", newAlarm.toMap());
    return res;
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final db = await databse;
    var res = await db
        .update('Alarm', alarm.toMap(), where: 'id=?', whereArgs: [alarm.id]);
    return res;
  }

  Future<void> blockOrUnblock(Alarm alarm) async {
    final db = await databse;
    Alarm status = Alarm(
        id: alarm.id,
        hour: alarm.hour,
        minute: alarm.minute,
        period: alarm.period,
        label: alarm.label,
        status: !alarm.status);
    var res = await db.update("Alarm", status.toMap(),
        where: "id = ?", whereArgs: [alarm.id]);
    return res;
  }

  getAllAlarms() async {
    final db = await databse;
    var res = await db.query("Alarm");
    List<Alarm> list =
        res.isNotEmpty ? res.map((c) => Alarm.fromMap(c)).toList() : [];
    return list;
  }

  deleteOne(int id) async {
    final db = await databse;
    db.delete('Alarm', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Alarm>> getOnAlarms() async {
    final db = await databse;
    var res = await db.rawQuery("SELECT * FROM Alarm WHERE status=1");
    List<Alarm> list =
        res.isNotEmpty ? res.map((c) => Alarm.fromMap(c)).toList() : [];
    return list;
  }

  getOnAlarmsCount() async {
    final db = await databse;
    var res = await db.rawQuery("SELECT * FROM Alarm WHERE status=1");
    List<Alarm> list =
        res.isNotEmpty ? res.map((c) => Alarm.fromMap(c)).toList() : [];
    return list.length;
  }
}
