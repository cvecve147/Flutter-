import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new TestApp());

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      home: new ListDisplay(),
    );
  }
}

//class ListDisplay extends StatelessWidget {
//  List<String> litems = ["1", "2", "Third", "4"];
//
//  @override
//  Widget build(BuildContext ctxt) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Dynamic Demo"),
//        ),
//        body: new ListView.builder(
//            itemCount: litems.length,
//            itemBuilder: (BuildContext ctxt, int index) {
//              return new Text(litems[index]);
//            }) // ListView.builder() shall be used here.
//        );
//  }
//}

class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DyanmicList();
}


class DyanmicList extends State<ListDisplay> {
  List<String> litems = ['1','2','3','1','2','3','1','2','3'];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Dynamic Demo"),),
        body: new Column(
          children: <Widget>[
            new TextField(
              controller: eCtrl,
              onSubmitted: (text) {
                litems.add(text);
                eCtrl.clear();
                setState(() {});
              },
            ),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(litems[index]);
                    }
                )
            )
          ],
        )
    );
  }
}
