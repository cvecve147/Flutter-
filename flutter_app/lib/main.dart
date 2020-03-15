import 'package:flutter/material.dart';
import 'package:flutter_app/DB/bluetooth_db.dart';
import 'package:flutter_app/DB/bluetooth_model.dart';
import 'package:flutter_app/DB/temperature_db.dart';
import 'package:flutter_app/DB/temperature_model.dart';
import 'DB/employee_db.dart';
import 'DB/employee_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Hello World",
      home: Scaffold(
          appBar: AppBar(
            title: Text("title"),
          ),
          body: ContentWidget()),
    );
  }
}

class ContentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContentWidgetState();
  }
}

class ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              setState(() async {
                var employee1 = new employee(
                  name: 'employee1',
                  employeeID: '1231213',
                );
                employeeSqlite employeedb = employeeSqlite();
                //employeedb.insertNewEmployee(employee1);
                print(await employeedb.insertNewEmployee(employee1));
                print(await employeedb.allEmployee());
              });
            },
            child: const Text('insert123', style: TextStyle(fontSize: 20)),
          ),
          // RaisedButton(
          //   onPressed: () {
          //     setState(() async {
          //       var employee1 = new employee(
          //         name: 'employee1',
          //         employeeID: '1231213',
          //       );
          //       employeeSqlite employeedb = employeeSqlite();
          //       //employeedb.insertNewEmployee(employee1);
          //       print(await employeedb.allEmployee());
          //     });
          //   },
          //   child: const Text('Search all', style: TextStyle(fontSize: 20)),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     setState(() async {
          //       var employee1 = new employee(
          //         name: 'employee1',
          //         employeeID: '1231213',
          //       );
          //       employeeSqlite employeedb = employeeSqlite();
          //       //employeedb.insertNewEmployee(employee1);
          //       print(await employeedb.searchEmployee(4));
          //     });
          //   },
          //   child: const Text('Search 1', style: TextStyle(fontSize: 20)),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     setState(() async {
          //       var employee1 = new employee(
          //         id: 12,
          //         name: 'employee12123',
          //         employeeID: '1231213',
          //       );
          //       employeeSqlite employeedb = employeeSqlite();
          //       //employeedb.insertNewEmployee(employee1);
          //       print(await employeedb.updateEmployee(employee1));
          //       print(await employeedb.allEmployee());
          //     });
          //   },
          //   child: const Text('update', style: TextStyle(fontSize: 20)),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     setState(() async {
          //       var employee1 = new employee(
          //         name: 'employee1',
          //         employeeID: '1231213',
          //       );
          //       employeeSqlite employeedb = employeeSqlite();
          //       //employeedb.insertNewEmployee(employee1);
          //       print(await employeedb.delEmployee(4));
          //       print(await employeedb.allEmployee());
          //     });
          //   },
          //   child: const Text('Del', style: TextStyle(fontSize: 20)),
          // ),
          RaisedButton(
            onPressed: () {
              setState(() async {
                var temperature1 =
                    new temperature(id: '123mac', temp: '23', time: '2020');
                temperatureSqlite tpDB = new temperatureSqlite();
                print(await tpDB.insertNewtemperature(temperature1));
//                print(await btDB.allbluetooth());
              });
            },
            child: const Text('tpinsert', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
