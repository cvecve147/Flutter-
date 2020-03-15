import 'dart:async';

import 'package:flutter_app/DB/employee_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class employeeSqlite {
  String _DbDir;
  String _Dbname = "NewApp.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) {
      return database.execute('''
        CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT,);
        CREATE TABLE bluetooths(id  TEXT, mac TEXT);
        CREATE TABLE temperatures(id TEXT, temp TEXT, time TEXT,);
      ''');
    }, version: 1);
  }

  insertNewEmployee(employee employee1) async {
    await initDB();
    await _DB.insert('employees', employee1.toMap());
    await _DB.close();
  }

  Future<List<employee>> allEmployee() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query('employees');
    await _DB.close();
    return List.generate(maps.length, (i) {
      //print("employee id ${ maps[i]['id']} name ${maps[i]['name']} employeeID ${maps[i]['employeeID']}");
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
      );
    });
  }

  Future<employee> searchEmployee(int id) async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.query(
      'employees',
      where: "id = ?",
      whereArgs: [id],
    );
    await _DB.close();
    return employee(
      id: maps[0]['id'],
      name: maps[0]['name'],
      employeeID: maps[0]['employeeID'],
    );
  }

  delEmployee(int id) async {
    await initDB();
    await _DB.delete("employees", where: "id = ?", whereArgs: [id]);
    await _DB.close();
  }

  updateEmployee(employee employee1) async {
    await initDB();
    await _DB.update(
      'employees',
      employee1.toMap(),
      where: "id = ?",
      whereArgs: [employee1.id],
    );
    await _DB.close();
  }
}
