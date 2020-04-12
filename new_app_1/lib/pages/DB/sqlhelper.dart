import 'dart:async';
import 'package:newapp1/pages/DB/AllJoin_model.dart';
import 'package:newapp1/pages/DB/employee_model.dart';
import 'package:newapp1/pages/DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'employee_model.dart';

class sqlhelper {
  String _DbDir;
  String _Dbname = "NewApp05.db";
  Database _DB;
  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) async {
      await database.execute('''
            CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT,mac TEXT DEFAULT NULL);
          ''');
      await database.execute('''
            CREATE TABLE temperatures(id INTEGER, temp TEXT,time TEXT);
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

  showLastDate() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery('''
      select * from temperatures
          ORDER BY temperatures.time DESC
    ''');
    return List.generate(maps.length, (i) {
      return temperature(
          id: maps[i]['id'], temp: maps[i]['temp'], time: maps[i]['time']);
    });
  }

  searchEmployee(int id) async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.query('employees', where: "id=?", whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
        mac: maps[i]['mac'],
      );
    });
  }

  searchEmployeeID(String id) async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.query('employees', where: "employeeID=?", whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
        mac: maps[i]['mac'],
      );
    });
  }

  searchEmployeeMAC(String mac) async {
    await initDB();
    final List<Map<String, dynamic>> maps =
        await _DB.query('employees', where: "mac=?", whereArgs: [mac]);
    return List.generate(maps.length, (i) {
      return employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        employeeID: maps[i]['employeeID'],
        mac: maps[i]['mac'],
      );
    });
  }

  searchTemp(String startData, String endData) async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery(
        "SELECT * FROM temperatures WHERE time BETWEEN '${startData}' AND '${endData}'"); //2020-01-01
    return List.generate(maps.length, (i) {
      return temperature(
          id: maps[i]['id'], temp: maps[i]['temp'], time: maps[i]['time']);
    });
  }

  updateData(dynamic data) async {
    await initDB();
    if (data is employee) {
      await _DB.update("employees", data.toMap(),
          where: "id=?", whereArgs: [data.id]);
    }
  }

  Future<String> readCsvToEmployee() async {
    try {
      List repeat = [];
      String _path = await FilePicker.getFilePath();
      final input = new File(_path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      for (int i = 0; i < fields.length; i++) {
        if (fields[i][0] == "人員編號") {
          continue;
        }
        List data = await searchEmployeeID(fields[i][0].toString());
        if (data.length > 0) {
          repeat.add(fields[i][0].toString());
        } else {
          employee data = employee(
              name: fields[i][1].toString(),
              employeeID: fields[i][0].toString(),
              mac: fields[i].length > 2 ? fields[i][2] : null);
          await insertData(data);
        }
      }
      if (repeat.length > 0) {
        return repeat.join("、") + "有重複 請檢察列表中的資料";
      } else {
        return "匯入成功";
      }
    } catch (e) {
      print(e);
      return "匯入失敗";
    }
  }

  showLastTemp() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery('''
      select * from employees         
      INNER JOIN 
      (
        select * from
        (select * from temperatures
          ORDER BY temperatures.time)          
          GROUP BY  id      
      )as temperatures
      on temperatures.id= employees.id
      ORDER BY temperatures.time  DESC
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

  Future<String> writeEmployeeToCsv(List date, [int id]) async {
    await initDB();
    List<Map<String, dynamic>> data;
    if (id != null) {
      data = await _DB.rawQuery('''select * from employees 
        INNER JOIN temperatures 
        on temperatures.id= employees.id
        WHERE employees.id = ${id}
        and WHERE temperatures.time BETWEEN '${date[0]}' AND '${date[1]}'
        ''');
      print(data);
    } else {
      data = await _DB.rawQuery('''select * from employees 
        INNER JOIN temperatures 
        on temperatures.id= employees.id
        WHERE temperatures.time BETWEEN '${date[0]}' AND '${date[1]}'
        ''');
    }
    String csvFormat = "";
    await List.generate(data.length, (i) {
      csvFormat += data[i]['time'] +
          "," +
          data[i]['name'] +
          "," +
          data[i]['temp'] +
          "\n";
    });
    try {
      Directory directory = await getExternalStorageDirectory();
      final File file = new File('${directory.path}/NewApp.csv');
      await file.writeAsString(csvFormat);
      return "${directory.path}/NewApp.csv";
    } catch (e) {
      return "${e}匯出失敗";
    }
  }

  deleteOverDay(String date) async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery(
        "SELECT * FROM temperatures WHERE time BETWEEN '2020-01-01' AND '${date}'"); //2020-01-01
    print(maps);
    List.generate(maps.length, (i) async {
      await _DB.delete("temperatures",
          where: "time=?", whereArgs: [maps[i]['time'].toString()]);
    });
  }

  deleteEmployee(int id) async {
    await initDB();
    await _DB.delete('employees', where: "id=?", whereArgs: [id]);
  }

  dropEmployee() async {
    await initDB();
    await _DB.delete('employees');
  }

  dropTemp() async {
    await initDB();
    await _DB.delete('temperatures');
  }

  dropAll() async {
    await initDB();
    await _DB.delete('employees');
    await _DB.delete('temperatures');
  }
}
