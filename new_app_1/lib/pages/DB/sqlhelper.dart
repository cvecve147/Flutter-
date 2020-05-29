import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';

import '../DB/AllJoin_model.dart';
import '../DB/employee_model.dart';
import '../DB/temperature_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'employee_model.dart';

import 'package:excel/excel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class sqlhelper {
  String _DbDir;
  String _Dbname = "NewApp07.db";
  Database _DB;

  initDB() async {
    _DbDir = await getDatabasesPath();
    _DB = await openDatabase(path.join(_DbDir, _Dbname),
        onCreate: (database, version) async {
      await database.execute('''
            CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,employeeID TEXT, name TEXT,mac TEXT DEFAULT NULL);
          ''');
      await database.execute('''
            CREATE TABLE temperatures(id INTEGER, temp TEXT,roomTemp TEXT,time TEXT,symptom TEXT DEFAULT NULL);
          ''');
    }, version: 4);
  }

  uploadDataTemp(temperature data) async {
    var url = 'http://120.105.161.209:3000/temps';
    try {
      await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          },
          body: jsonEncode(await data.toJson()));
    } catch (e) {
      print(e);
    }
  }

  uploadDataUser(employee data) async {
    var url = 'http://120.105.161.209:3000/users';
    try {
      await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          },
          body: jsonEncode(await data.toJson()));
    } catch (e) {
      print(e);
    }
  }

  editServerData(employee data) async {
    var url = 'http://120.105.161.209:3000/users/${data.id}';
    try {
      await http.put(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          },
          body: jsonEncode(await data.toJson()));
    } catch (e) {
      print(e);
    }
  }

  deleteServerData(int data) async {
    var url = 'http://120.105.161.209:3000/users/${data}';
    try {
      await http.delete(
        url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String> insertData(dynamic data) async {
    await initDB();
    if (data is employee) {
      List searchData = await searchEmployeeID(data.employeeID);
      if (data.id == 0 || searchData.length > 0) {
        return "請檢查資料";
      }
      await _DB.insert('employees', data.toMap());
      var res = await showEmployeeLast();
      try {
        await uploadDataUser(res);
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await _DB.insert('temperatures', data.toMap());
        await uploadDataTemp(data);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<employee> showEmployeeLast() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery('''
          SELECT * FROM employees ORDER BY id DESC LIMIT 1
    ''');
    return employee(
      id: maps[0]['id'],
      name: maps[0]['name'],
      employeeID: maps[0]['employeeID'],
      mac: maps[0]['mac'],
    );
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
          id: maps[i]['id'],
          roomTemp: maps[i]['roomTemp'],
          temp: maps[i]['temp'],
          time: maps[i]['time'],
          symptom: maps[i]['symptom']);
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
        roomTemp: maps[i]['roomTemp'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
        symptom: maps[i]['symptom'],
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
          id: maps[i]['id'],
          roomTemp: maps[i]['roomTemp'],
          temp: maps[i]['temp'],
          time: maps[i]['time'],
          symptom: maps[i]['symptom']);
    });
  }

  Future<List<employee>> searchEmployee(int id) async {
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
          id: maps[i]['id'],
          roomTemp: maps[i]['roomTemp'],
          temp: maps[i]['temp'],
          time: maps[i]['time'],
          symptom: maps[i]['symptom']);
    });
  }

  updateData(dynamic data) async {
    await initDB();
    if (data is employee) {
      await _DB.update("employees", data.toMap(),
          where: "id=?", whereArgs: [data.id]);
      await editServerData(data);
    }
  }

  Future<String> readCsvToEmployee() async {
    List repeat = [];
    try {
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
        print(data);
        if (data.length > 0) {
          repeat.add(fields[i][0].toString());
        } else {
          employee data = employee(
              name: fields[i][1].toString(),
              employeeID: fields[i][0].toString(),
              mac: fields[i].length > 2 ? fields[i][2].toString() : null);
          await insertData(data);
        }
      }
      return "匯入成功";
    } catch (e) {
      print(e);
      return repeat.join("、") + "有重複 請檢查列表中的資料";
    }
  }

  showLastData() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery('''
      select * from employees         
      INNER JOIN 
      (
        select * from
        (select * from temperatures
          ORDER BY temperatures.time DESC)          
          GROUP BY  id      
      )as temperatures
      on temperatures.id= employees.id
      ORDER BY temperatures.time 
    ''');
    return List.generate(maps.length, (i) {
      return AllJoinTable(
        id: maps[i]['id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        mac: maps[i]['mac'],
        roomTemp: maps[i]['roomTemp'],
        temp: maps[i]['temp'],
        time: maps[i]['time'],
        symptom: maps[i]['symptom'],
      );
    });
  }

  showLastTemp() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _DB.rawQuery('''
      select * from employees        
      ORDER BY employeeID
    ''');
    return List.generate(maps.length, (i) {
      return AllJoinTable(
        id: maps[i]['id'],
        employeeID: maps[i]['employeeID'],
        name: maps[i]['name'],
        mac: maps[i]['mac'],
        roomTemp: "",
        temp: "",
        time: "",
        symptom: "",
      );
    });
  }

  String twoDigit(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  Future<String> writeEmployeeToCsv(List date, [int id]) async {
    await initDB();
    List<Map<String, dynamic>> data;

    String idAndName = "";
    Directory directory = await getExternalStorageDirectory(); //取得内部储存空间
    var now = new DateTime.now();
    String fileName = twoDigit(now.year) +
        "-" +
        twoDigit(now.month) +
        "-" +
        twoDigit(now.day) +
        "_" +
        twoDigit(now.hour) +
        "-" +
        twoDigit(now.minute) +
        "-" +
        twoDigit(now.second);
    if (id != null) {
      try {
        data = await _DB.rawQuery('''
                  select * from
                  (select * from employees WHERE employees.id = ${id})
                  as employees
                  INNER JOIN temperatures
                  on temperatures.id= employees.id
                  WHERE temperatures.time BETWEEN '${date[0]}' AND '${date[1]}'
                  ordey by temperatures.time ASC
                    ''');
        List<employee> searchData = await searchEmployee(id);
        idAndName = searchData[0].employeeID + "_" + searchData[0].name;
        fileName += (id != null) ? "_${idAndName}" : "";
        List<String> csvFormat2 = ["時間", "體溫", "模組溫度", "備註"];
        createExcelfiles(directory.path, fileName, csvFormat2, data, true);
      } catch (e) {
        return "${e}匯出失敗";
      }
      print(data);
    } else {
      try {
        data = await _DB.rawQuery('''select * from employees 
        INNER JOIN temperatures 
        on temperatures.id= employees.id
        WHERE temperatures.time BETWEEN '${date[0]}' AND '${date[1]}'
        ordey by employees.employeeID ,temperatures.time ASC
        ''');
        print(data);
        fileName += (id != null) ? "_${idAndName}" : "";
        List<String> csvFormat2 = ["員工編號", "時間", "姓名", "體溫", "模組溫度", "備註"];
        createExcelfiles(directory.path, fileName, csvFormat2, data, false);
      } catch (e) {
        return "${e}匯出失敗";
      }
    }
    try {
      return "${directory.path}/${fileName}.csv";
    } catch (e) {
      return "${e}匯出失敗";
    }
  }

  createExcelfiles(String directory, String fileName, List<String> header,
      List<Map<String, dynamic>> data, bool person) {
    var excel = Excel.createExcel();
    final File file = new File('${directory}/${fileName}.xlsx');

    var sheet = 'Sheet1';
    var sheetcol = ["A", "B", "C", "D", "E", "F"];
    for (int i = 0; i < header.length; i++) {
      excel.updateCell(
          sheet,
          CellIndex.indexByString(sheetcol[i].toString() + 1.toString()),
          header[i]);
    }
    if (person) {
      List.generate(data.length, (i) {
        String symptom = "";
        if (data[i]['symptom'] != null) {
          symptom = data[i]['symptom'];
        }
        excel.updateCell(sheet,
            CellIndex.indexByString("A" + (i + 2).toString()), data[i]['time']);
        excel.updateCell(sheet,
            CellIndex.indexByString("B" + (i + 2).toString()), data[i]['temp']);
        excel.updateCell(
            sheet,
            CellIndex.indexByString("C" + (i + 2).toString()),
            data[i]['roomTemp']);
        excel.updateCell(
            sheet, CellIndex.indexByString("D" + (i + 2).toString()), symptom);
      });
    } else {
      List.generate(data.length, (i) {
        String symptom = "";
        if (data[i]['symptom'] != null) {
          symptom = data[i]['symptom'];
        }
        excel.updateCell(
            sheet,
            CellIndex.indexByString("A" + (i + 2).toString()),
            data[i]['employeeID']);
        excel.updateCell(sheet,
            CellIndex.indexByString("B" + (i + 2).toString()), data[i]['time']);
        excel.updateCell(sheet,
            CellIndex.indexByString("C" + (i + 2).toString()), data[i]['name']);
        excel.updateCell(sheet,
            CellIndex.indexByString("D" + (i + 2).toString()), data[i]['temp']);
        excel.updateCell(
            sheet,
            CellIndex.indexByString("E" + (i + 2).toString()),
            data[i]['roomTemp']);
        excel.updateCell(
            sheet, CellIndex.indexByString("F" + (i + 2).toString()), symptom);
      });
    }

    String outputFile = "${directory}/${fileName}.xlsx";
    excel.encode().then((onValue) {
      File(join(outputFile))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
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
    await deleteServerData(id);
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
