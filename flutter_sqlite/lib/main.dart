import 'package:flutter/material.dart';
import 'DB/sqlhelper.dart';
import 'package:fluttersqlite/DB/employee_model.dart';
import 'package:fluttersqlite/DB/temperature_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() async {
      sqlhelper sqlhepler = new sqlhelper();
      // insert
      // employee data = new employee(name: "張三", employeeID: "12");
      // temperature data = new temperature(time: "2020-01-01", temp: "23");
      // await sqlhepler.insertData(data);
      // update
      // employee data = new employee(id: 1,name: "張三", employeeID: "12",mac: "123");
      // sqlhepler.updateData(data);

      //search
      // print(await sqlhepler.searchEmployee(1));
      // print(await sqlhepler.searchTemp("2020-01-01", "2020-01-07"));

      //delete
      // sqlhepler.deleteEmployee(1);

      print(await sqlhepler.showEmployee());
      print(await sqlhepler.showtemperature());
      print(await sqlhepler.showEmployeeJoinTemp());
    });
  }

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
