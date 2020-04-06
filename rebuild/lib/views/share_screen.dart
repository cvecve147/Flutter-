import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  ShareScreen({Key key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("share")),
    );
  }
}
