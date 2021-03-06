// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Tem_Tracker/pages/people_screen.dart';
import '../DB/sqlhelper.dart';
import '../DB/employee_model.dart';
import '../DB/temperature_model.dart';
import 'package:Tem_Tracker/app_localizations.dart';

//List allData;

class Scan extends StatefulWidget {
  Scan({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

//  final String na;
//  final String id;
//  final List<String> items;

  //必需重写createState方法
  @override
  ScanResultTile createState() => new ScanResultTile(result, onTap);
}

class ScanResultTile extends State<Scan> {
  //StatelessWidget
//  ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);
  ScanResult result;
  VoidCallback onTap;

//  String na;
//  String id;
//  List<String> items;
  ScanResultTile(this.result, this.onTap);

  List<String> numList = [];
  List<String> macL = [];
  List<String> nameList = [];

//  List<String> checkList = [];

  Widget _buildTitle(BuildContext context) {
    //先判斷有無Name
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Name
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis, //無視省略號(...)
          ),

          //MacAddress
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget getTempWidgets(
      context, List<String> macL, List<String> tempL, List<String> rssiL) {
    createConfirmDataAlertDialog(
      BuildContext context,
      String mac,
      String temp,
      String rssi,
      int i,
    ) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate('alertDialog_update')//"量測確認"
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                              .translate('staff_num') +//"編號："
                              "："+ rssi),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                              .translate('staff_name') +//"姓名："
                              "：" + mac),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                              .translate('alertDialog_measuring_temperature') +//"量測溫度："
                              "：" + temp),
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
                      child: Text(AppLocalizations.of(context)
                          .translate('alertDialog_confirm')//'確認'
                      ),
                      // ignore: missing_return
                      onPressed: () {
                        insertData(macL, tempL, rssiL, i);
                        Navigator.of(context).pop();
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)
                                .translate('alertDialog_confirm_success')//'確認成功'
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                              .translate('staff_num') +//"編號："
                                              "：" + rssi),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                              .translate('staff_name') +//"姓名："
                                              "：" + mac),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                              .translate('alertDialog_measuring_temperature') +//"量測溫度："
                                              "：" + temp),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
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

    //    print(macL);print(tempL);print(rssiL);
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < macL.length; i++) {
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
                tempL[i],
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.right,
              ),
              title: Text(
                macL[i],
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                rssiL[i],
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '確認',
              color: Color(0xFF81E9E6),
              icon: Icons.check_circle,
              onTap: () => createConfirmDataAlertDialog(
                  context, confirmName, tempL[i], macL[i], confirmPosition),
            ),
          ],
        ),
      );
    }
    return new Column(children: list);
  }

  //設計
  Widget _buildAdvRow(BuildContext context, String title, String value) {
//    createAddPeopleAlertDialog(context);
    return Padding(
      //對稱型的padding，分別設定水平和垂直的值
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //靠上
        children: <Widget>[
          //左側
          Text(title, style: Theme.of(context).textTheme.caption),

          //兩側中間留白
          SizedBox(
            width: 12.0,
          ),

          //右側
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  //取得16進制array
  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String transValue(correct, bytes) {
    String t =
        '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
            .toUpperCase();
    var data1, data2, data3, data4, pid, check1, check2;
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    if (correct == '8796' && check1 == '59' && check2 == '80' && pid == '03') {
      data1 = bytes
          .elementAt(4)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data2 = bytes
          .elementAt(5)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data3 = bytes
          .elementAt(6)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      data4 = bytes
          .elementAt(7)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase()
          .toString();
      double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
          toRadix(data4)); //decodeTempLevel(data,0);
      return tem.toString(); //+data2+data3+data4
    } else {
      return correct;
    }
  }

  String checkAddress(correct, bytes) {
    var pid, check1, check2;
    check1 = bytes
        .elementAt(0)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    check2 = bytes
        .elementAt(1)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    pid = bytes
        .elementAt(2)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase()
        .toString();
    return correct + check1 + check2 + pid;
  }

  String transTemp(bytes) {
    var data1, data2, data3, data4, data;
    data = bytes.split(',');
    data1 = data[0].trim(); //trim():將字符串兩邊去除空格處理
    data2 = data[1].trim();
    data3 = data[2].trim();
    data4 = data[3].trim();
    print(data1);
    print(data2);
    print(data3);
    print(data4);
    double tem = bytesToFloat(toRadix(data1), toRadix(data2), toRadix(data3),
        toRadix(data4)); //decodeTempLevel(data,0);
    return formatNum(tem, 2); //+data2+data3+data4
  }

  //溫度小數取到第二位
  formatNum(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      return num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  int toRadix(x) {
    var first, sec;
    first = x.substring(0, 1);
    switch (first) {
      case 'F':
        {
          first = 15;
        }
        break;
      case 'E':
        {
          first = 14;
        }
        break;
      case 'D':
        {
          first = 13;
        }
        break;
      case 'C':
        {
          first = 12;
        }
        break;
      case 'B':
        {
          first = 11;
        }
        break;
      case 'A':
        {
          first = 10;
        }
        break;
      default:
        {
          first = int.parse(first);
        }
    }
    sec = x.substring(1, 2);
    switch (sec) {
      case 'F':
        {
          sec = 15;
        }
        break;
      case 'E':
        {
          sec = 14;
        }
        break;
      case 'D':
        {
          sec = 13;
        }
        break;
      case 'C':
        {
          sec = 12;
        }
        break;
      case 'B':
        {
          sec = 11;
        }
        break;
      case 'A':
        {
          sec = 10;
        }
        break;
      default:
        {
          sec = int.parse(sec);
        }
    }
    var ans = first * 16 + sec;
    return ans & 0xFF;
  }

  //判斷是否為華星tag
  bool tagis(Map<int, List<int>> data1, Map<String, List<int>> data2, mac) {
    macL.add(mac);
    var check;
    List<String> res1 = [], res2 = [];
    data1.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      check = '${checkAddress(c, bytes)}';
      res1.add('${checkAddress(c, bytes)}');
    });
    data2.forEach((id, bytes) {
      res2.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    if (check == '8796598003') {
      return true;
    } else {
      return false;
    }
  }

  //取得16進制array
  String trans(List<int> bytes) {
    return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
        .toUpperCase();
  }

  //取得製造商資訊
  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  //取得室溫資訊
  String getRoomTempData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      res.add('${transValue(c, bytes)}');
    });
    return res.join(', ');
  }

  //取得體溫資料
  String getBodyTempData(Map<String, List<int>> data) {
    //String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
//    res.add('${trans(data[1])}');
    data.forEach((id, bytes) {
      res.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.elementAt(0);
  }

  //取得溫度資料
  String getTempData(Map<int, List<int>> data1, Map<String, List<int>> data2) {
    var check;
    List<String> res1 = [], res2 = [];
    data1.forEach((id, bytes) {
      var c = '${id.toRadixString(16).toUpperCase()}';
      check = '${checkAddress(c, bytes)}';
      res1.add('${checkAddress(c, bytes)}');
    });
    data2.forEach((id, bytes) {
      res2.add(
          '${trans(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    if (check == '8796598003') {
      return transTemp(res2.elementAt(1));
    } else {
      return res1.elementAt(0);
    }
  }

  //取得服務資料
  String getNiceServiceData(Map<String, List<int>> data) {
    //String
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toUpperCase()}: ${getNiceHexArray(bytes)}'); //${id.toUpperCase()}  ${getNiceHexArray(bytes)}
    });
    return res.join(', ');
  }

  Future<String> searchData() async {
    sqlhelper sqlhepler = new sqlhelper();
    List a = await sqlhepler.showEmployee();
    return a[0].name;
  }

  Future<void> insertData(macL, tempL, rssiL, int i) async {
    sqlhelper sqlhepler = new sqlhelper();
    var a = await sqlhepler.searchEmployeeMAC(macL[i]);
    temperature data =
        new temperature(id: a[0].id, temp: tempL[i], time: getCurrentDate());
    await sqlhepler.insertData(data);
//    print(await sqlhepler.showtemperature());
  }

  getCurrentDate() {
    var now = new DateTime.now();
    String nowYear = now.year.toString();
    String nowMonth, nowDay;
    if (now.month < 10) {
      nowMonth = "0" + now.month.toString();
    }
    if (now.day < 10) {
      nowDay = "0" + now.day.toString();
    }

    String nowHour;
    String nowMin;
    String nowSec;

    if (now.hour < 10) {
      nowHour = "0" + now.hour.toString();
    }
    if (now.minute < 10) {
      nowMin = "0" + now.minute.toString();
    }
    if (now.second < 10) {
      nowSec = "0" + now.month.toString();
    }
    String currentDate = nowYear + "-" + nowMonth + "-" + nowDay;
    String currentTime = nowHour + "-" + nowMin + "-" + nowSec;
    return currentDate + " " + currentTime;
  }

  title(String allmac, String mac, String name) {
    if (allmac == mac) {
      return name;
    } else {
      return mac;
    }
  }

  Future<String> downloadData(macList) async {
    sqlhelper helper = new sqlhelper();
    if (tagis(result.advertisementData.manufacturerData,
            result.advertisementData.serviceData, macList[0]) ==
        true) {
      var a = await helper.searchEmployeeMAC(macList[0].toString());
      print(a);
      if (a.length != 0) {
        nameList.add(a[0].name.toString());
        numList.add(a[0].employeeID);
      } else {
        nameList.add(macList[0].toString());
        numList.add("0");
      }
    }
//      print(macList);
    print(macList);
    return Future.value("Get Data"); // return your response
  }

  @override
  Widget build(BuildContext context) {
    List<String> tempList = [];
    List<String> rssiList = [];
    List<String> macList = [];
    macList.add(result.device.id.toString());
    tempList.add(getTempData(result.advertisementData.manufacturerData,
        result.advertisementData.serviceData));
    rssiList.add(result.rssi.toString());

    createConfirmDataAlertDialog(BuildContext context, mac, int i) {
      debugPrint("Position:" + confirmPosition.toString());
      debugPrint("data:" + data[confirmPosition].toString());
      debugPrint("name:" + data[confirmPosition].name);
      debugPrint("employeeID:" + data[confirmPosition].employeeID);
      debugPrint("MAC:" + mac);

      String confirmEmployeeID;
      String confirmEmployeeName;

      confirmEmployeeID = data[confirmPosition].employeeID;
      confirmEmployeeName = data[confirmPosition].name;

      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate('alertDialog_pairing_confirmation')//"配對確認"
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)
                              .translate('staff_num') +//"編號："
                              "：" + confirmEmployeeID),
                          Text(AppLocalizations.of(context)
                              .translate('staff_name') +//"姓名："
                              "：" + confirmEmployeeName),
                          Text("Mac：" + mac),
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
                      child: Text(AppLocalizations.of(context)
                          .translate('alertDialog_confirm')//'確認'
                          ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        sqlhelper helper = new sqlhelper();
                        employee employeeData = new employee(
                            id: data[confirmPosition].id,
                            employeeID: confirmEmployeeID,
                            name: confirmEmployeeName,
                            mac: mac);
                        await helper.updateData(employeeData);
                        Navigator.of(context).pop();
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)
                                  .translate('alertDialog_matching_result')//'配對結果'
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(AppLocalizations.of(context)
                                        .translate('alertDialog_paired_success')//"配對成功"
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      color: appColor,
                    ),
                    new FlatButton(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('alertDialog_cancel')//'取消'
                        , style: new TextStyle(color: appColor),
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

    return FutureBuilder<String>(
      future: downloadData(macList), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        List<Widget> list = new List<Widget>();
        if (snapshot.hasData) {
          if (tagis(result.advertisementData.manufacturerData,
                  result.advertisementData.serviceData, macList[0]) &&
              nameList.length > 0) {
            if (nameList[0] == macList[0]) {
              for (var i = 0; i < macList.length; i++) {
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
                          tempList[i],
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        title: Text(
                          nameList.length <= 0 ? "" : nameList[i],
//                      title(allData[i].mac.toString(),macList[i],allData[i].name.toString()),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          numList.length <= 0 ? "" : numList[i],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: AppLocalizations.of(context)
                      .translate('alertDialog_confirm'),//'確認'
                        color: Color(0xFF81E9E6),
                        icon: Icons.check_circle,
                        onTap: () => createConfirmDataAlertDialog(
                            context, macList[i], i),
                      ),
                    ],
                  ),
                );
              }
            }
          }
          return new Column(children: list);
        } else {
          return new Column();
        }
      },
    );
  }

  createConnectPeopleAlertDialog(
      BuildContext context, String name, String mac, String temp, String num) {
    TextEditingController editNameController = new TextEditingController();
    TextEditingController editNumController = new TextEditingController();
//    editNameController.text = name;
//    editNumController.text = num;
    print(1);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)
                .translate('alertDialog_person_pairing')//"人員配對"
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
                                  .translate('staff_name'),//'姓名',
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
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)
                                  .translate('staff_num'),//'編號',
                            ),
                            controller: editNumController,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
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
                    child: Text(AppLocalizations.of(context)
                        .translate('alertDialog_confirm')//'確認'
                    ),
                    // ignore: missing_return
                    onPressed: () async {
                      sqlhelper helper = new sqlhelper();
                      String n = editNameController.text;
                      String number = editNumController.text;
                      if (n != "") {
                        Navigator.of(context).pop();
                        debugPrint(name);
                        if (number != "") {
                          insertData(mac, temp, number, 0);
                          employee employeeData = new employee(
                              employeeID: number, name: n, mac: mac);
                          await helper.insertData(employeeData);
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Result'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)
                                          .translate('staff_name') +//"姓名："
                                          "：" + n),
                                      Text(AppLocalizations.of(context)
                                          .translate('staff_num') +//"編號："
                                          "："  + number),
                                      Text("Mac Address：" + mac),
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
                                        Text(AppLocalizations.of(context)
                                            .translate('alertDialog_please_enter_the_number')//"請輸入編號"
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
                                      Text(AppLocalizations.of(context)
                                          .translate('alertDialog_please_enter_your_name')//"請輸入姓名"
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
                          .translate('alertDialog_cancel')//'取消'
                      ,style: new TextStyle(color: appColor),
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

  double bytesToFloat(b0, b1, b2, b3) {
//    int mantissa = unsignedToSigned(b0 + (b1 << 8) + (b2 << 16), 24);
    b3 = -2;
    int mantissa = unsignedToSigned(
        unsignedByteToInt(b0) +
            (unsignedByteToInt(b1) << 8) +
            (unsignedByteToInt(b2) << 16),
        24);
    //(mantissa * pow(10, int.parse(b3)))
    return (mantissa * pow(10, b3));
  }

  int unsignedByteToInt(b) {
    return b & 0xFF;
  }

  int unsignedToSigned(int unsigned, int size) {
    if ((unsigned & (1 << size - 1)) != 0) {
      unsigned = -1 * ((1 << size - 1) - (unsigned & ((1 << size - 1) - 1)));
    }
    return unsigned;
  }
}