import 'dart:async';

import 'package:fluttersqlite/DB/bluetooth_model.dart';
import 'package:fluttersqlite/DB/employee_model.dart';
import 'package:fluttersqlite/DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class bluetoothsql{
  String _DbDir;
  String _Dbname = "NewApp0.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version)async {
          await database.execute('''
            CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT);
          ''');
          await database.execute('''
            CREATE TABLE bluetooths(bluetoothid  TEXT, bluetoothmac TEXT);
          ''');
          await database.execute('''
            CREATE TABLE temperatures(id  TEXT, temp TEXT,time TEXT);
          ''');
        }, version: 3);
  }
  insertData(dynamic data) async{
    await initDB();
    if(data is employee){
      await _DB.insert('employees', data.toMap());
    }else if(data is bluetooth){
      await _DB.insert('bluetooths', data.toMap());
    }else{
      await _DB.insert('temperatures', data.toMap());
    }
  }
  Future<List<employee>> showEmployee() async{
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('employees');
    return List.generate(maps.length, (i) {
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
      );
    });
  }
  Future<List<bluetooth>> showBluetooth() async{
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('bluetooths');
    return List.generate(maps.length, (i) {
      return bluetooth(
        id: maps[i]['bluetoothid'],
        mac: maps[i]['bluetoothmac'],
      );
    });

  }
  Future<List<temperature>> showtemperature() async{
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('temperatures');
    return List.generate(maps.length, (i) {
      return temperature(
        id: maps[i]['id'],
        temp: maps[i]['temp'],
        time:maps[i]['time']
      );
    });
  }

}