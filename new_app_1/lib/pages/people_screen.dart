import 'dart:convert';
import 'dart:math';

import 'package:newapp1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:newapp1/pages/DB/sqlhelper.dart';
import 'package:newapp1/pages/DB/employee_model.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:newapp1/pages/bluetooth/package.dart';
import 'package:newapp1/pages/scan_screen.dart';
import 'package:newapp1/app_localizations.dart';

Color appColor = Color(0xFF2A6FDB);
Color cashColor = Color(0xFFFEFCBF);

String confirmName = "";
int confirmPosition;

getData() async {
  sqlhelper helper = new sqlhelper();
//  employee data=new employee(employeeID: "12",name: "123");
//  temperature data=new temperature(id:1,time: "2020-01-12",temp: "25.6");
//  helper.insertData(data);
//  print(await helper.showEmployee());
  return await helper.showEmployee();
}

class Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContentState();
  }
}

List data;

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: downloadData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        List<Widget> list;
        if (snapshot.hasData) {
          list = new List<Widget>();
          for (var i = 0; i < data.length; i++) {
            if (data[i].mac.toString() == ":::::" ||
                data[i].mac.toString() == "") {
//              print(data[i].id.toString() + "," + data[i].mac.toString() + "未配對");
              list.add(
                new Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Text(
                          data[i].employeeID.toString(),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      trailing: Text(
                        data[i].mac.toString(),
                        style: TextStyle(
                          fontSize: 22,
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
//                      subtitle: Text(
//                        data[i].employeeID.toString(),
//                        style: TextStyle(
//                          fontSize: 16,
//                        ),
//                        textAlign: TextAlign.left,
//                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate('alertDialog_update'), //'修改'
                      color: cashColor,
                      icon: Icons.edit,
                      onTap: () => createEditPeopleAlertDialog(
                        context,
                        data[i],
                      ),
                    ),
                    IconSlideAction(
                        caption: AppLocalizations.of(context)
                            .translate('alertDialog_pair'), //'配對',
                        color: Colors.blue,
                        icon: Icons.bluetooth_connected,
                        onTap: () async {
                          FlutterBlue.instance
                              .startScan(timeout: Duration(seconds: 4));
                          await createPairPeopleAlertDialog(
                              context, data[i].name, i);
                          await setState(() {});
                        }),
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate('alertDialog_delete'), //'刪除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => createDeletePeopleAlertDialog(
                          context,
                          data[i].name,
                          data[i].mac.toString(),
                          data[i].employeeID.toString(),
                          data[i].id),
                    ),
                  ],
                ),
              );
            } else {
//              print(data[i].id.toString() + "已配對");
              list.add(
                new Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Text(
                          data[i].employeeID.toString(),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      trailing: Text(
                        data[i].mac.toString(),
                        style: TextStyle(
                          fontSize: 22,
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
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate('alertDialog_update'), //'修改'
                      color: cashColor,
                      icon: Icons.edit,
                      onTap: () => createEditPeopleAlertDialog(
                        context,
                        data[i],
                      ),
                    ),
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate('alertDialog_cancel_pair'), //'取消配對',
                      color: Colors.pink,
                      icon: Icons.bluetooth_disabled,
                      onTap: () async {
                        checkData.remove(data[i].mac.toString());
                        print("按下取消配對");
                        sqlhelper helpler = new sqlhelper();
                        employee editData = employee(
                            id: data[i].id,
                            employeeID: data[i].employeeID,
                            name: data[i].name,
                            mac: "");
                        await helpler.updateData(editData);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(data[i].name +
                                  AppLocalizations.of(context).translate(
                                      'alertDialog_remove_connection')
//                              "已解除配對"
                              ),
                        ));
                        setState(() {});
                      },
                    ),
                    IconSlideAction(
                      caption: AppLocalizations.of(context)
                          .translate('alertDialog_delete'), //'刪除',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => createDeletePeopleAlertDialog(
                          context,
                          data[i].name,
                          data[i].mac.toString(),
                          data[i].employeeID.toString(),
                          data[i].id),
                    ),
                  ],
                ),
              );
            }
          }
          return new Column(children: list);
        } else {
          return Text(
            AppLocalizations.of(context).translate('alertDialog_no_data'),
//              '無資料'
          );
        }
      },
    );
  }

  createDeletePeopleAlertDialog(
      BuildContext context, String name, String mac, String num, int idNum) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)
                  .translate('alertDialog_delete_confirm'), //刪除確認
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('staff_delete_check'), //'確定要刪除此資料？'
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context)
                                    .translate('staff_name') +
                                "：" //'姓名：'
                            ),
                        Text(name),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context)
                                    .translate('staff_num') +
                                "："
//                            '編號：'
                            ),
                        Text(num),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate('staff_address') +
                                "：" +
                                mac,
                            softWrap: true,
//                            'MAC編碼：'
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('alertDialog_confirm'),
//                        '確認'
                    ),
                    // ignore: missing_return
                    onPressed: () async {
                      checkData.remove(mac);
                      sqlhelper helpler = new sqlhelper();
                      await helpler.deleteEmployee(idNum);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('alertDialog_cancel'),
//                      '取消',
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

  TextEditingController editNameController = new TextEditingController();
  TextEditingController editNumController = new TextEditingController();
  List<TextEditingController> _editMaccontroller = [
    for (int i = 1; i < 7; i++) TextEditingController()
  ];

  createEditPeopleAlertDialog(BuildContext context, dynamic data) {
    editNameController.text = data.name;
    editNumController.text = data.employeeID.toString();

    if (data.mac == "") {
      for (int i = 0; i < 6; i++) {
        _editMaccontroller[i].text = "";
      }
    } else {
      var macSpilt = data.mac.toString().split(":");
      for (int i = 0; i < 6; i++) {
        _editMaccontroller[i].text = macSpilt[i];
      }
    }

    Widget getMacWidgets() {
      List<Widget> list = new List<Widget>();
      for (var i = 0; i < 11; i++) {
        if (i % 2 == 0) {
          int $Control = (i / 2).toInt();
          list.add(
            new Flexible(
              child: new TextField(
                maxLength: 2,
                controller: _editMaccontroller[$Control],
              ),
            ),
          );
        } else {
          list.add(
            Text(":"),
          );
        }
      }
      return new Row(children: list);
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('update_staff'),
//                "修改人員"
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)
                                        .translate('staff_num') +
                                    "："
//                              '編號',
                                ),
                            keyboardType: TextInputType.number,
                            controller: editNumController,
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
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)
                                        .translate('staff_name') +
                                    "："
//                              '姓名'
                                ),
                            controller: editNameController,
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
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('alertDialog_confirm'),
//                        '確認'
                    ),
                    onPressed: () async {
                      if (_editMaccontroller[0].text == "" ||
                          _editMaccontroller[1].text == "" ||
                          _editMaccontroller[2].text == "" ||
                          _editMaccontroller[3].text == "" ||
                          _editMaccontroller[4].text == "" ||
                          _editMaccontroller[5].text == "") {
                        sqlhelper helpler = new sqlhelper();
                        employee editData = employee(
                            id: data.id,
                            employeeID: editNumController.text,
                            name: editNameController.text,
                            mac: "");
                        String result = await helpler.updateData(editData);
                        print(result);
                        setState(() {});
                        Navigator.of(context).pop();
                      } else {
                        sqlhelper helpler = new sqlhelper();
                        employee editData = employee(
                            id: data.id,
                            employeeID: editNumController.text,
                            name: editNameController.text,
                            mac: _editMaccontroller[0].text +
                                ":" +
                                _editMaccontroller[1].text +
                                ":" +
                                _editMaccontroller[2].text +
                                ":" +
                                _editMaccontroller[3].text +
                                ":" +
                                _editMaccontroller[4].text +
                                ":" +
                                _editMaccontroller[5].text);
                        String result = await helpler.updateData(editData);
                        print(result);
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                    color: appColor,
                  ),
                  new FlatButton(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('alertDialog_cancel'),
//                      '取消',
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

  createPairPeopleAlertDialog(BuildContext context, name, position) {
    confirmPosition = position;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context).translate('alertDialog_pair')
//                "配對 "
                    +
                    name),
            content: RefreshIndicator(
              onRefresh: () =>
                  FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
              child: SingleChildScrollView(
                //SingleChildScrollView滾動條
                child: Column(
                  children: <Widget>[
                    //當已經connect上後才顯示的部分，少了RSSI與詳細資訊，多了open按鍵//
                    StreamBuilder<List<BluetoothDevice>>(
                      //用于創建一个周期性發送事件的串流Stream.periodic //asyncMap異步
                      stream: Stream.periodic(Duration(seconds: 2)).asyncMap(
                          (_) => FlutterBlue.instance.connectedDevices),
                      //initialData初始資料為空
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        //ListTile 通常用於在 Flutter 中填充 ListView
                        children: snapshot.data
                            .map((d) =>
//                      getTempWidgets(nameList, tempList, numList)
                                ListTile(
                                  //名稱
                                  title: Text(d.name),
                                  //mac
                                  subtitle: Text(d.id.toString()),
                                ))
                            .toList(),
                      ),
                    ),

//              所有搜尋到的結果列表
                    StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data
                            .map(
                              (r) => Scan(
                                result: r,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<String> downloadData() async {
    data = await getData();
    sqlhelper helper = new sqlhelper();
    print(await helper.showEmployee());
    return Future.value("Get Data");
  }
}

class PeopleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PeopleScreenState();
  }
}

class PeopleScreenState extends State<PeopleScreen> {
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
          Text(":"),
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
            title: Text(
              AppLocalizations.of(context).translate('insert_staff'),
//                "新增人員"
            ),
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
                                labelText: AppLocalizations.of(context)
                                        .translate('staff_num') +
                                    "："
//                              '編號'
                                ),
                            keyboardType: TextInputType.number,
                            controller: numController,
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
                                labelText: AppLocalizations.of(context)
                                        .translate('staff_name') +
                                    "："
//                              '姓名'
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
                      child: getMacWidgets()),
                ],
              ),
            ),
            actions: <Widget>[
              new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('alertDialog_confirm'),
//                        '確認'
                    ),
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
                        debugPrint(name);
                        if (num != "") {
                          if (_maccontroller[0].text == "" ||
                              _maccontroller[1].text == "" ||
                              _maccontroller[2].text == "" ||
                              _maccontroller[3].text == "" ||
                              _maccontroller[4].text == "" ||
                              _maccontroller[5].text == "") {
                            macAddress = "";
                          }
                          employee data = new employee(
                              employeeID: num, name: name, mac: macAddress);
                          String result = await helper.insertData(data);
                          setState(() {});
                          Navigator.of(context).pop();
                          print(result);
                          if (result ==
                                  AppLocalizations.of(context)
                                      .translate('alertDialog_check_data')
//                              "請檢查資料"
                              ) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)
                                          .translate('toast_fail_add_staff')
//                                      '新增人員失敗'
                                      ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'toast_repeat_staff_num_or_name'),
//                                            "人員編號重複，請重新新增"
                                        ),
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
                                  title: Text(
                                    AppLocalizations.of(context)
                                        .translate('toast_success_add_staff'),
//                                      '新增人員成功'
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(AppLocalizations.of(context)
                                                .translate('staff_num') +
                                            "："
//                                            "編號："
                                            +
                                            num),
                                        Text(AppLocalizations.of(context)
                                                .translate('staff_name') +
                                            "："
//                                            "姓名："
                                            +
                                            name),
                                        Text(AppLocalizations.of(context)
                                                .translate('staff_address') +
                                            "："
//                                            "Mac Address："
                                            +
                                            macAddress),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
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
                                        Text(
                                            AppLocalizations.of(context).translate(
                                                    'alertDialog_please_insert') +
                                                AppLocalizations.of(context)
                                                    .translate('staff_num')
//                                            "請輸入編號"
                                            ),
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
                                      Text(
                                          AppLocalizations.of(context).translate(
                                                  'alertDialog_please_insert') +
                                              AppLocalizations.of(context)
                                                  .translate('staff_name')
//                                          "請輸入姓名"
                                          ),
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
                      AppLocalizations.of(context)
                          .translate('alertDialog_cancel'),
//                      '取消',
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
        title: Text(
          AppLocalizations.of(context).translate('staff_management'),
//            "人員管理"
        ),
        centerTitle: true,
        backgroundColor: appColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: AppLocalizations.of(context).translate('insert_staff')
//            '新增人員'
            ,
            onPressed: () {
              createAddPeopleAlertDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.input),
          tooltip: AppLocalizations.of(context)
              .translate('import_staff_data_button'),
//          '匯入人員資料',
          onPressed: () async {
            sqlhelper helpler = new sqlhelper();
//            await helpler.readCsvToEmployee();
            String result = await helpler.readCsvToEmployee();
            print(result);
            if (result == "匯入成功") {
              setState(() {});
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context)
                          .translate('import_staff_data_button') +
                      AppLocalizations.of(context)
                          .translate('toast_alert_success'),
//                    "人員資料匯入成功"
                ),
              ));
            } else {
              setState(() {});
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context)
                          .translate('import_staff_data_button') +
                      AppLocalizations.of(context)
                          .translate('toast_alert_success'),
//                    "人員資料匯入失敗"
                ),
              ));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Content()],
        ),
      ),
    );
  }

  Future<void> searchData() async {
    sqlhelper hepler = new sqlhelper();
//    var employee =await hepler.searchEmployeeMAC("11:11:21:11"); //id
    employee data1 = new employee(
        name: "ivy", employeeID: "1", id: 1, mac: "30:45:11:3E:30:E5");
    await hepler.updateData(data1);
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
