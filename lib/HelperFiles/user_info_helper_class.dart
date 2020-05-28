import 'dart:io';
import 'package:sleep_tracker/model/user_info_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class UserInfoDatabaseHelper {
  UserInfoDatabaseHelper._();

  static final UserInfoDatabaseHelper db = UserInfoDatabaseHelper._();
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
    String path = join(documentsDirectory.path, "UserInfo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE UserInfo (id INTEGER PRIMARY KEY,day INTEGER,month INTEGER,year INTEGER,age INTEGER,lastName TEXT,firstName TEXT,height REAL,weight REAL,bmi REAL,idealSleep INTEGER,idealWater INTEGER)');
        });
  }

  Future<void> insertUserInfo(User userInfo) async {
    final db = await database;
    var res = await db.insert("UserInfo", userInfo.toMap());
    return res;
  }

  getAllUserInfo() async {
    final db = await database;
    var res = await db.query("UserInfo");
    List<User> list =
    res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  getUserInfo(int id) async {
    final db = await database;
    var res = await db.query("UserInfo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : Null;
  }

  Future<void> updateUserInfo(User data) async {
    final db = await database;
    var res = await db
        .update('UserInfo', data.toMap(), where: 'id=?', whereArgs: [data.id]);
    return res;
  }


}
