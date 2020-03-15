import 'dart:async';

import 'package:flutter_app/DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class temperatureSqlite {
  String _DbDir;
  String _Dbname = "NewApp.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) {
      return database.execute('''
        
      ''');
    }, version: 1);
  }

  insertNewtemperature(temperature temperature1) async {
    await initDB();
    await _DB.insert('temperatures', temperature1.toMap());
    await _DB.close();
  }

  Future<List<temperature>> alltemperature() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('temperatures');
    await _DB.close();
    return List.generate(maps.length, (i) {
      return temperature(
        id: maps[i]['id'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
      );
    });
  }

  Future<temperature> searchtemperature(int id) async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query(
      'temperatures',
      where: "id = ?",
      whereArgs: [id],
    );
    await _DB.close();
    return temperature(
      id: maps[0]['id'],
      temp: maps[0]['temp'],
      time: maps[0]['time'],
    );
  }
}
