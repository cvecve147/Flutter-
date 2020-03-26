import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';

Color appColor = Color(0xFF2A6FDB);

Widget getTextWidgets(
    List<String> nameL, List<String> addressL, List<String> numberL) {
  List<Widget> list = new List<Widget>();
  for (var i = 0; i < nameL.length; i++) {
    list.add(
      new Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              child: Icon(Icons.person),
              foregroundColor: Colors.white,
            ),
            trailing: Text(
              addressL[i],
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
            title: Text(
              nameL[i],
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              numberL[i],
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '配對',
            color: Colors.blue,
            icon: Icons.settings_ethernet,
//              onTap: () => _showSnackBar('Archive'),
          ),
          IconSlideAction(
            caption: '刪除',
            color: Colors.red,
            icon: Icons.delete,
//                onTap: () => _showSnackBar('Delete'),
          ),
        ],
      ),
    );
  }
  return new Column(children: list);
}

// ignore: must_be_immutable
class PeopleScreen extends StatelessWidget {
  Widget getMacWidgets() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 11; i++) {
      if (i % 2 == 0) {
        int $Control = (i / 2).toInt();
        list.add(
          new Flexible(
            child: new TextField(
              maxLength: 2,
              controller: _maccontroller[$Control],
            ),
          ),
        );
      } else {
        list.add(
          Text("-"),
        );
      }
    }
    return new Row(children: list);
  }

  List<TextEditingController> _maccontroller = [
    for (int i = 1; i < 7; i++) TextEditingController()
  ];
  TextEditingController nameController = new TextEditingController();
  TextEditingController numController = new TextEditingController();

  createAddPeopleAlertDialog(BuildContext context) {
    nameController.text = "";
    numController.text = "";

    for (int i = 0; i < 6; i++) {
      _maccontroller[i].text = "";
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("新增人員"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
//                      Text('姓名：'),
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '姓名',
                            ),
                            controller: nameController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
//                      Text('姓名：'),
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '編號',
                            ),
                            controller: numController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: getMacWidgets()),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    // ignore: missing_return
                    onPressed: () {
                      String name = nameController.text;
                      String num = numController.text;
                      String macAddress = _maccontroller[0].text.toUpperCase() +
                          "-" +
                          _maccontroller[1].text.toUpperCase() +
                          "-" +
                          _maccontroller[2].text.toUpperCase() +
                          "-" +
                          _maccontroller[3].text.toUpperCase() +
                          "-" +
                          _maccontroller[4].text.toUpperCase() +
                          "-" +
                          _maccontroller[5].text.toUpperCase();
                      if (name != "") {
                        debugPrint(name);
                        if (num != "") {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("姓名："+name),
                                      Text("編號："+num),
                                      Text("Mac Address："+macAddress),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Result'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text("請輸入編號"),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      } else {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("請輸入姓名"),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      '取消',
                      style: new TextStyle(color: appColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<String> nameList = [
      'Izaan',
      'Charlize',
      'Madihah',
      'Rian',
      'Ellisha',
      'Farhan'
    ];
    List<String> macList = [
      '53-A9-A3-FE-A3-95',
      '6A-8B-6E-FD-34-3F',
      '18-7B-E3-65-A6-59',
      'F3-04-32-25-8F-8F',
      '59-72-03-83-A8-67',
      '1E-28-95-A6-57-D7'
    ];

    List<String> numList = ['1', '2', '3', '4', '5', '6'];

    return Scaffold(
        appBar: AppBar(
          title: Text("人員管理"),
          backgroundColor: appColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: '新增人員',
              onPressed: () {
                createAddPeopleAlertDialog(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              getTextWidgets(nameList, macList, numList),
            ],
          ),
        ));
  }
}

class People extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeopleState();
  }
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
