import 'dart:io';
// import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';

class DataBaseHelper {
  static final _databasename = 'Users';
  static final _databaseversion = 1;

  static final table = 'Mytable';

  static final columnId = 'id';
  static final columnName = 'username';
  static final columnPassword = 'userpassword';
  static final columnEmail = 'useremail';
  static final columnSecretKey = 'usersecretkey';
  static Database _database;

  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  Future<Database> get data_base async {
    if (_database != null) return _database;

    _database = await _initDataBase();
    return _database;
  }

  _initDataBase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(documentDirectory.path, _databasename);
    return await openDatabase(databasePath,
        version: _databaseversion, onCreate: _oncreate);
  }

  Future _oncreate(Database db, int version) async {
    await db.execute('CREATE TABLE $table('
        '$columnId INTEGER PRIMARY KEY,'
        '$columnName TEXT,'
        '$columnPassword TEXT,'
        '$columnEmail TEXT,'
        '$columnSecretKey TEXT )');
  }

  Future<String> insert(Map<String, dynamic> row) async {
    // print(row);
    Database db = await instance.data_base;
    var res = await db
        .query(table, where: "username = ?", whereArgs: [row['username']]);
    // print("res  = $res");
    if (res.length < 1) {
      var check = await db.insert(table, row);
      // print(check);
      return "created";
    } else {
      var check = await update(row['username'], row['userpassword'],
          row['useremail'], row['usersecretkey']);
      // print(check);
      return check;
    }
  }

  Future<List<Map<String, dynamic>>> query_all() async {
    Database db = await instance.data_base;
    return await db.query(table);
  }

  Future<String> update(String user_name, String user_password,
      String user_email, String user_secret_key) async {
    Database db = await instance.data_base;
    var res = await db.update(
        table,
        {
          'userpassword': user_password,
          'useremail': user_email,
          'usersecretkey': user_secret_key
        },
        where: "$columnName = ?",
        whereArgs: [user_name]);
    // print(res);
    // return 'User $user_name updated';
    return 'updated';
  }

  Future<String> verify_userabc(String user_id, String user_password) async {
    Database db = await instance.data_base;
    var res =
        await db.query(table, where: "username = ?", whereArgs: [user_id]);
    // print("res  = $res");
    try {
      if (res.length < 1) return "Invalid Username";
      // res = await db.query(table, where: "userpassword = ?", whereArgs: [user_password]);
      // print("res  = $res");
      if (res[0]['userpassword'] != user_password) return "Invalid Password";
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      var dateData = formatted.split('-');
      // print(dateData);
      var keyData =
          (res[0]['usersecretkey']).split('-'); //[yyyy-mm-dd-androidId]
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var myAndroidId = androidInfo.androidId;
      // print("myandroidId = ${myAndroidId}");
      if (myAndroidId == keyData[0]) {
        if (int.parse(keyData[1]) > int.parse(dateData[0])) return "valid user";
        if (int.parse(keyData[1]) == int.parse(dateData[0])) {
          if (int.parse(keyData[2]) > int.parse(dateData[1]))
            return "valid user";
          if (int.parse(keyData[2]) == int.parse(dateData[1])) {
            if (int.parse(keyData[3]) >= int.parse(dateData[2]))
              return "valid user";
          }
        }
        return "Validity Over Please Contact To Mr. Azad.";
      }
      return "Invalid Secret Key";
    } catch (e) {
      return "Wrong Credientials!!!";
    }
    // return res[0]['usersecretkey'];
  }

  Future<List<Map<String, dynamic>>> getNoteMapList(String userName) async {
    Database db = await this.data_base;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result =
        await db.query(table, where: "username = ?", whereArgs: [userName]);
    // print(result);
    return result;
    // return result.forEach(row);
  }

  Future<List<User>> getNoteList(String userName) async {
    var noteMapList =
        await getNoteMapList(userName); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<User> noteList = <User>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(User.fromMap(noteMapList[i]));
      // print(noteList);
    }

    return noteList;
  }
}
