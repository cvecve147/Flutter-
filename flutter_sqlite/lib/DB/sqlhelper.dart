import 'dart:async';

import 'package:fluttersqlite/DB/bluetooth_model.dart';
import 'package:fluttersqlite/DB/employee_model.dart';
import 'package:fluttersqlite/DB/EmployeeJoinBluetooth_model.dart';
import 'package:fluttersqlite/DB/AllJoin_model.dart';
import 'package:fluttersqlite/DB/EmployeeJoinTemp_model.dart';
import 'package:fluttersqlite/DB/BluetoothJoinTemp_model.dart';
import 'package:fluttersqlite/DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class sqlhelper {
  String _DbDir;
  String _Dbname = "NewAppx.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) async {
      await database.execute('''
            CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT);
          ''');
      await database.execute('''
            CREATE TABLE bluetooths(bluetoothid  TEXT, bluetoothmac TEXT);
          ''');
      await database.execute('''
            CREATE TABLE temperatures(id  TEXT, temp TEXT,time INTEGER);
          ''');
    }, version: 4);
  }

  insertData(dynamic data) async {
    await initDB();
    if (data is employee) {
      await _DB.insert('employees', data.toMap());
    } else if (data is bluetooth) {
      await _DB.insert('bluetooths', data.toMap());
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
      );
    });
  }

  Future<List<bluetooth>> showBluetooth() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('bluetooths');
    return List.generate(maps.length, (i) {
      return bluetooth(
        id: maps[i]['bluetoothid'],
        mac: maps[i]['bluetoothmac'],
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

  showEmployeeJoinBluetooth() async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.rawQuery('''select * from employees 
        INNER JOIN bluetooths 
        on bluetooths.bluetoothid= employees.employeeID''');
    return List.generate(maps.length, (i) {
      return EmployeeJoinBluetooth(
        id: maps[i]['id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        mac: maps[i]['bluetoothmac'],
      );
    });
  }

  showEmployeeJoinTemp() async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.rawQuery('''select * from employees 
        INNER JOIN temperatures 
        on temperatures.id= employees.employeeID''');
    return List.generate(maps.length, (i) {
      return EmployeeJoinTemp(
        id: maps[i]['employees.id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
      );
    });
  }

  showBluetoothJoinTemp() async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.rawQuery('''select * from bluetooths 
        INNER JOIN temperatures 
        on temperatures.id= bluetooths.bluetoothid''');
    return List.generate(maps.length, (i) {
      return BluetoothJoinTemp(
        id: maps[i]['bluetoothid'],
        mac: maps[i]['bluetoothmac'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
      );
    });
  }

  showAllJoin() async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.rawQuery('''select * from employees 
        INNER JOIN bluetooths 
        on bluetooths.bluetoothid= employees.employeeID
        INNER JOIN temperatures 
        on temperatures.id= employees.employeeID
        
        ''');
    return List.generate(maps.length, (i) {
      return AllJoinTable(
        id: maps[i]['employees.id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        mac: maps[i]['bluetoothmac'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
      );
    });
  }
}
