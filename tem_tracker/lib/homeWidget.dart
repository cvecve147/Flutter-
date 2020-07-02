import 'package:flutter/material.dart';
import 'pages/scan_screen.dart';
import 'pages/share_screen.dart';
import 'pages/people_screen.dart';
import 'pages/test.dart';
import 'app_localizations.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PeopleScreen(),
    //FlutterBlueApp(),
//    ScanScreen(),
    statefulScanScreen(),
    ShareScreen(),
//    ListDisplay(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('New App For NurseMaid'),
//        centerTitle: true, // this is all you need
//      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: new Icon(Icons.people),
            title: new Text(
//                '人員管理'
              AppLocalizations.of(context).translate('staff_management'),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.track_changes),
            title: new Text(
              AppLocalizations.of(context).translate('tem_mea'),
//                '體溫量測'
            ),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.share),
              title: Text(
                AppLocalizations.of(context).translate('export_data'),
//              '資料匯出'
              )),
        ],
      ),
    );
  }
}
