import 'package:flutter/material.dart';
import 'homeWidget.dart';

void main() => runApp(MyApp());

List<String> macL = [];
List<String> checkData = [];
List<Map<String, dynamic>> checkListData = [
  {
    "id": "",
    "temp": "",
    "time": "",
  }
];
print(checkListData[0]);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkData.clear();
    return MaterialApp(
      title: 'New App for NurseMaid',
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New APP'),
      ),
      body: Center(
        child: Column(),
      ),
    );
  }
}
