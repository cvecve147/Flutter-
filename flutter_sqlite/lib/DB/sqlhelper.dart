import 'dart:async';
import 'package:fluttersqlite/DB/employee_model.dart';
import 'package:fluttersqlite/DB/AllJoin_model.dart';
import 'package:fluttersqlite/DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class sqlhelper {
  String _DbDir;
  String _Dbname = "NewApp02.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) async {
      await database.execute('''
            CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT,mac TEXT DEFAULT NULL);
          ''');
      await database.execute('''
            CREATE TABLE temperatures(id INTEGER, temp TEXT,time INTEGER);
          ''');
    }, version: 4);
  }

  insertData(dynamic data) async {
    await initDB();
    if (data is employee) {
      await _DB.insert('employees', data.toMap());
    } else {
      await _DB.insert('temperatures', data.toMap());
    }
  }

  Future<List<employee>> showEmployee() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('employees');
    return List.generate(maps.length, (i) {
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
        mac: maps[i]['mac'],
      );
    });
  }

  Future<List<temperature>> showtemperature() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('temperatures');
    return List.generate(maps.length, (i) {
      return temperature(
          id: maps[i]['id'], temp: maps[i]['temp'], time: maps[i]['time']);
    });
  }

  showEmployeeJoinTemp() async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.rawQuery('''select * from employees 
        INNER JOIN temperatures 
        on temperatures.id= employees.id
        ''');
    return List.generate(maps.length, (i) {
      return AllJoinTable(
        id: maps[i]['id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        mac: maps[i]['mac'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
      );
    });
  }

  updateData(dynamic data) async {
    await initDB();
    if (data is employee) {
      await _DB.update("employees", data.toMap(),
          where: "id=?", whereArgs: [data.id]);
    } else {
      await _DB.update("temperatures", data.toMap(),
          where: "id=?", whereArgs: [data.id]);
    }
  }

  readCsvToEmployee() async {}

  writeEmployeeToCsv() async {}

  dropAll() async {
    await initDB();
    await _DB.delete('employees');
    await _DB.delete('temperatures');
  }
}
