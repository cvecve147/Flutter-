import 'dart:async';

import 'package:flutter_app/DB/bluetooth_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class bluetoothSqlite {
  String _DbDir;
  String _Dbname = "NewApp.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) {
      return database.execute('''
        CREATE TABLE bluetooths(id  TEXT PRIMARY KEY, mac TEXT)
      ''');
    }, version: 1);
  }

  insertNewbluetooth(bluetooth bluetooth1) async {
    print(await initDB());
    await _DB.insert('bluetooths', bluetooth1.toMap());
    await _DB.close();
  }

  Future<List<bluetooth>> allbluetooth() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('bluetooths');
    await _DB.close();
    return List.generate(maps.length, (i) {
      return bluetooth(
        id: maps[i]['id'],
        mac: maps[i]['mac'],
      );
    });
  }

  Future<bluetooth> searchbluetooth(int id) async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query(
      'bluetooths2',
      where: "id = ?",
      whereArgs: [id],
    );
    await _DB.close();
    return bluetooth(
      id: maps[0]['id'],
      mac: maps[0]['mac'],
    );
  }

  delbluetooth(int id) async {
    await initDB();
    await _DB.delete("bluetooths2", where: "id = ?", whereArgs: [id]);
    await _DB.close();
  }

  updatebluetooth(bluetooth bluetooth1) async {
    await initDB();
    await _DB.update(
      'bluetooths2',
      bluetooth1.toMap(),
      where: "id = ?",
      whereArgs: [bluetooth1.id],
    );
    await _DB.close();
  }
}
