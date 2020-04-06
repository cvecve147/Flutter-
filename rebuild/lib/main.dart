import 'package:flutter/material.dart';
import './views/people_screen.dart';
import './views/scan_screen.dart';
import './views/share_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New App for NurseMaid',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PeopleScreen(),
    ScanScreen(),
    ShareScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        }, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.people),
            title: Text('人員管理'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            title: Text('體溫量測'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.share), title: Text('資料匯出')),
        ],
      ),
    );
  }
}
