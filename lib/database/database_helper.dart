import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_crud_sample/main.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table_name = 'note_table';

  static final columnId = "_id";
  static final columnTitle = "title";
  static final columnContent = "content";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // opens the database/creates the database if the database is not existing
  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate
    );
  }

  // code to create database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table_name (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL
          )
          ''');
  }

  /*
  * Helper methods - enables the CRUD functionalities
  */

  // for inserting new notes, returns ID of inserted row
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_name, row);
  }

  // all rows are returned as list of maps
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table_name);
  }

  // returns the row count of the table
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.query('SELECT COUNT(*) FROM $table_name'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table_name, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // delete a row in the table given the id
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table_name, where: '$columnId = ?', whereArgs: [id]);
  }

}