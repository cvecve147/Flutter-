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

  void _incrementCounter() async {
    sqlhelper sqlhepler = new sqlhelper();
    // employee data=employee(name:"123",employeeID: "123");
    // await sqlhepler.insertData(data);
    // print(await sqlhepler.showEmployee());


    // await sqlhepler.readCsvToEmployee();
    print(await sqlhepler.showEmployee());
    List data=[];

    await sqlhepler.writeEmployeeToCsv(data);
    print("read");
    print(await sqlhepler.read());
//    dynamic map = sqlhepler.searchEmployeeMAC("");
//    print(map);
//    await sqlhepler.readCsvToEmployee();
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
