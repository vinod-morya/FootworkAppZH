import 'dart:async';
import 'dart:io';

import 'package:footwork_chinese/model/loginResponse/LoginResponseModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseHelper {
  final String tableUser = "userDataTable";

  final String columnUserName = "username";
  final String columnPassword = "password";
  final String columnNiceName = "nicename";
  final String columnEmail = " email";
  final String columnUrl = "url";
  final String columnRegistered = "registered";
  final String columnDisplayName = "displayname";
  final String columnFirstName = "firstname";
  final String columnLastName = "lastname";
  final String columnNickname = "nickname";
  final String columnDescription = "description";
  final String columnAvatar = "avatar";
  final String columnUserId = "id";
  final String capabilities = "capabilities";
  final String columnUserCountry = "country";
  final String columnUserState = "state";
  final String columnUserCity = "city";
  final String columnUserPostCode = "postcode";
  final String columnUserPhone = "phone";
  final String columnUserRole = "user_role";
  final String columnUserAddress = "address";

  final String tableCountry = "countryDataTable";

  final String countryName = "name";
  final String countryId = "code";

  static final DataBaseHelper instance = DataBaseHelper.init();

  factory DataBaseHelper() => instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DataBaseHelper.init();

  initDB() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "footwork.db");

    var ourDB = await openDatabase(path, version: 6, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnUserId INTEGER PRIMARY KEY, $columnUserName TEXT, $columnPassword TEXT, $columnNiceName TEXT, $columnEmail TEXT, $columnUrl TEXT, $columnRegistered TEXT, $columnDisplayName TEXT, $columnFirstName TEXT, $columnLastName TEXT, $columnNickname TEXT, $columnAvatar TEXT, $columnDescription TEXT, $capabilities TEXT, $columnUserRole TEXT, $columnUserPhone TEXT, $columnUserPostCode TEXT, $columnUserCity TEXT, $columnUserState TEXT, $columnUserCountry TEXT, $columnUserAddress TEXT)");
//    await db.execute(
//        "CREATE TABLE $tableCountry(_Id INTEGER PRIMARY KEY AUTOINCREMENT, $countryName TEXT, $countryId TEXT)");
  }

  //user table functions
  Future<int> saveUser(UserBean user) async {
    var dbClient = await db;
    int result = await dbClient.insert("$tableUser", user.toJson());
    return result;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) from $tableUser"));
  }

  Future<UserBean> getUser(int ID) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableUser WHERE $columnUserId=$ID");
    return result.length == 0 ? null : new UserBean.fromJson(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUser, where: "$columnUserId = ?", whereArgs: [id]);
  }

  Future<int> updateUser(UserBean user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toJson(),
        where: "$columnUserId=?", whereArgs: [user.id]);
  }

//  country table functions
//  void saveCountryList(List<CountriesListBean> list) async {
//    var dbClient = await db;
//    for (int i = 0; i < list.length; i++) {
//      await dbClient.insert("$tableCountry", list[i].toJson());
//    }
//  }

//  Future<List> getCountryList() async {
//    var dbClient = await db;
//    return (await dbClient.rawQuery("SELECT * FROM $tableCountry")).toList();
//  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
