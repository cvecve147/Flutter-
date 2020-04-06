import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ScanScreen")),
    );
  }
}
