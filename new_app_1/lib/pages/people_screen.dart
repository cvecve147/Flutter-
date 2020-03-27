import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:newapp1/pages/DB/sqlhelper.dart';
import 'package:newapp1/pages/DB/employee_model.dart';

Color appColor = Color(0xFF2A6FDB);

getData() async {
  sqlhelper helper = new sqlhelper();
//  employee data=new employee(employeeID: "12",name: "123");
//  temperature data=new temperature(id:1,time: "2020-01-12",temp: "25.6");
//  helper.insertData(data);
//  print(await helper.showEmployee());
  return await helper.showEmployee();
}

class content extends StatelessWidget {
  List data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        List<Widget> list;
        if (snapshot.hasData) {
          list = new List<Widget>();
          for (var i = 0; i < data.length; i++) {
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
                      data[i].mac.toString(),
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    title: Text(
                      data[i].name.toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Text(
                      data[i].employeeID.toString(),
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
        }else{
          return Text('無資料');
        }
      },

    );
  }
  Future<String> downloadData() async {
    data = await getData();
    sqlhelper helper=new sqlhelper();
    print(await helper.showEmployee());
    return Future.value("Get Data");
  }
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
                    onPressed: () async{
                      sqlhelper helper=new sqlhelper();

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
                      employee data=new employee(employeeID: num,name:name,mac:  macAddress);
                      await helper.insertData(data);
                      if (name != "") {
                        Navigator.of(context).pop();
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
              content()
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
