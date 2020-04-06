import 'package:flutter/material.dart';
import 'package:rebuild/DB/employee_model.dart';
import 'package:rebuild/DB/sqlhelper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

class PeopleScreen extends StatefulWidget {
  PeopleScreen({Key key}) : super(key: key);

  @override
  PeopleScreenState createState() => PeopleScreenState();
}

void showMySimpleDialog(BuildContext context, [id, name, employeeID, mac]) {
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

class PeopleScreenState extends State<PeopleScreen> {
  void showMySimpleDialog(BuildContext context, [id, name, employeeID, mac]) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("人員管理"),
        centerTitle: true,
        backgroundColor: appColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: '新增人員',
            onPressed: () {
              showMySimpleDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.input),
          tooltip: '匯入人員',
          onPressed: () async {
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text("Pressing inport button."),
//              ));
            sqlhelper helpler = new sqlhelper();
            await helpler.readCsvToEmployee();
          },
        ),
      ),
      body: Body(),
    );
  }
}

List<TextEditingController> _maccontroller = [
  for (int i = 1; i < 7; i++) TextEditingController()
];
TextEditingController nameController = new TextEditingController();
TextEditingController numController = new TextEditingController();

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List Data = [];
  @override
  void initState() {
    super.initState();
    (() async {
      sqlhelper helper = sqlhelper();
      Data = await helper.showEmployee();
      setState(() {});
    })();
  }

  @override
  Widget build(BuildContext context) {
    var length = Data.length;
    var list = List.generate(length, (i) {
      return Slidable(
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
              Data[i].mac.toString(),
              style: TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.right,
            ),
            title: Text(
              Data[i].name.toString(),
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
            subtitle: Text(
              Data[i].employeeID.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '修改',
            color: cashColor,
            icon: Icons.edit,
            onTap: () => showMySimpleDialog(context, Data[i].name,
                Data[i].mac.toString(), Data[i].employeeID.toString()),
          ),
          IconSlideAction(
            caption: '配對',
            color: Colors.blue,
            icon: Icons.settings_ethernet,
            onTap: () => showMySimpleDialog(context),
          ),
          IconSlideAction(
            caption: '刪除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => showMySimpleDialog(context, Data[i].name,
                Data[i].mac.toString(), Data[i].employeeID.toString()),
          ),
        ],
      );
    });
    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
