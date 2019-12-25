
import 'package:sqflite/sqflite.dart';

import 'dart:async';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ton_tin_local/items/Items.dart';

class DatabaseHelper {



  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper

  static Database _database;                // Singleton Database



  String tableTongTin = 'tongtin_table';

  String colId = 'id';
  String colPaidMonth = 'paidmonth';
  String colPeople = 'people';
  String colCreateOn = 'createon';
  String colStartOn = 'starton';
  String colAmount = 'amount';
  String colInterest = 'interest';
  String colTitle = 'title';
  String colIsDead = 'isdead';

  String colListTrack = 'listtrack';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper



  factory DatabaseHelper() {



    if (_databaseHelper == null) {

      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object

    }

    return _databaseHelper;

  }



  Future<Database> get database async {



    if (_database == null) {

      _database = await initializeDatabase();

    }

    return _database;

  }



  Future<Database> initializeDatabase() async {

    // Get the directory path for both Android and iOS to store database.

    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'tontins.db';



    // Open/create the database at a given path

    var tongTinDatabase = await openDatabase(path, version: 4, onCreate: _createDb, onUpgrade: _onUpgrade );

    return tongTinDatabase;

  }



  void _createDb(Database db, int newVersion) async {



    await db.execute('CREATE TABLE $tableTongTin($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '

        '$colPeople INTEGER, $colPaidMonth INTEGER, $colCreateOn INTEGER, $colStartOn INTEGER, $colAmount DOUBLE, $colIsDead INTEGER , $colInterest DOUBLE )');

  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE $tableTongTin ADD COLUMN $colListTrack TEXT;");
    }
  }



  // Fetch Operation: Get all todo objects from database

  Future<List<Map<String, dynamic>>> getTongTinMapList({bool sort = false}) async {

    var sortBy = sort ? 'ASC' : 'DESC';
    Database db = await this.database;



//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');

    var result = await db.query(tableTongTin, orderBy: '$colId $sortBy');
    print('result: $result');
    return result;

  }



  // Insert Operation: Insert a todo object to database

  Future<int> insertTongTin(TongTinItem tongTin) async {

    Database db = await this.database;

    var result = await db.insert(tableTongTin, tongTin.toMap());

    return result;

  }



  // Update Operation: Update a todo object and save it to database

  Future<int> updateTongTin(TongTinItem tongTin) async {

    var db = await this.database;

    var result = await db.update(tableTongTin, tongTin.toMap(), where: '$colId = ?', whereArgs: [tongTin.id]);

    return result;

  }







  // Delete Operation: Delete a todo object from database

  Future<int> deleteTongTin(int id) async {

    var db = await this.database;

    int result = await db.rawDelete('DELETE FROM $tableTongTin WHERE $colId = $id');

    return result;

  }



  // Get number of todo objects in database

  Future<int> getCount() async {

    Database db = await this.database;

    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableTongTin');

    int result = Sqflite.firstIntValue(x);

    return result;

  }



  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]

  Future<List<TongTinItem>> getTodoList({bool sort = false}) async {



    var tongTinMapList = await getTongTinMapList(sort: sort); // Get 'Map List' from database

    int count = tongTinMapList.length;         // Count the number of map entries in db table



    List<TongTinItem> listTongTin = List<TongTinItem>();

    // For loop to create a 'todo List' from a 'Map List'

    for (int i = 0; i < count; i++) {

      listTongTin.add(TongTinItem.fromMap(tongTinMapList[i]));

    }



    return listTongTin;

  }



}