import 'package:flutter/material.dart';
import 'package:rebuild/DB/employee_model.dart';
import 'package:rebuild/DB/sqlhelper.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);
List<TextEditingController> _maccontroller = [
  for (int i = 1; i < 7; i++) TextEditingController()
];
TextEditingController nameController = new TextEditingController();
TextEditingController numController = new TextEditingController();

class showMySimpleDialogs extends State {
  showMySimpleDialog(BuildContext context, [id, name, employeeID, mac]) {
    showDialog(
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
                            keyboardType: TextInputType.number,
                            controller: numController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 16)),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text('確認'),
                    // ignore: missing_return
                    onPressed: () async {
                      sqlhelper helper = new sqlhelper();

                      String name = nameController.text;
                      String num = numController.text;
                      String macAddress = _maccontroller[0].text.toUpperCase() +
                          ":" +
                          _maccontroller[1].text.toUpperCase() +
                          ":" +
                          _maccontroller[2].text.toUpperCase() +
                          ":" +
                          _maccontroller[3].text.toUpperCase() +
                          ":" +
                          _maccontroller[4].text.toUpperCase() +
                          ":" +
                          _maccontroller[5].text.toUpperCase();
                      if (name != "") {
                        Navigator.of(context).pop();
                        debugPrint(name);
                        if (num != "") {
                          employee data = new employee(
                              employeeID: num, name: name, mac: macAddress);
                          await helper.insertData(data);
                          setState(() {});
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("姓名：" + name),
                                      Text("編號：" + num),
                                      Text("Mac Address：" + macAddress),
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
    // TODO: implement build
    return null;
  }
}
